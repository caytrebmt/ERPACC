import io

from flask import render_template


def render_pdf(template_name, context, base_url=None):
    """Render a server-side template to PDF when WeasyPrint is available.

    WeasyPrint depends on native Pango/Cairo libraries which are not present in
    every deployment image. Import it lazily so the ERP application can still
    boot and routes with ReportLab fallbacks remain available; PDF callers can
    handle the clear RuntimeError and choose their fallback engine.
    """
    try:
        from weasyprint import HTML, default_url_fetcher
    except (ImportError, OSError) as exc:
        raise RuntimeError(
            "WeasyPrint is unavailable; install its native Pango/Cairo "
            "dependencies or use a ReportLab fallback."
        ) from exc

    def _safe_url_fetcher(url):
        return default_url_fetcher(url, timeout=10)

    html = render_template(template_name, **context)
    pdf_io = io.BytesIO()
    HTML(
        string=html,
        base_url=base_url,
        url_fetcher=_safe_url_fetcher,
    ).write_pdf(pdf_io)
    pdf_io.seek(0)
    return pdf_io
