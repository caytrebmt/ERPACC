from flask import Blueprint, Response, request
from flask_login import login_required, current_user
import json
import queue
import threading
import time

from app.domains.ecommerce.routes.ecommerce import _broadcast

erp_events_bp = Blueprint('erp_events', __name__, url_prefix='/api/erp/events')

_clients = []
_client_lock = threading.Lock()


@erp_events_bp.get('')
@login_required
def events():
    q = queue.Queue()
    with _client_lock:
        _clients.append({'user_id': current_user.id, 'queue': q})
    try:
        while True:
            msg = q.get()
            yield msg
    except GeneratorExit:
        with _client_lock:
            try:
                _clients[:] = [c for c in _clients if c['queue'] is not q]
            except ValueError:
                pass


@erp_events_bp.get('/last')
@login_required
def events_last():
    return {'ok': True, 'ts': time.time()}


def broadcast_to_erp(event_type, payload):
    msg = json.dumps({'type': event_type, 'data': payload, 'ts': time.time()}, ensure_ascii=False)
    dead = []
    with _client_lock:
        for c in _clients:
            try:
                c['queue'].put_nowait(msg)
            except Exception:
                dead.append(c)
        for c in dead:
            _clients[:] = [x for x in _clients if x['queue'] is not c['queue']]
