--
-- PostgreSQL database dump
--

\restrict kRwcjZDIYkX2GbzbrSPCZpmSm4AOyisgLB1HegPdTfy8psGkC2hPBhExX1UH1cm

-- Dumped from database version 12.4
-- Dumped by pg_dump version 18.0

-- Started on 2026-07-22 17:37:03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: bamboo
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO bamboo;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 68066)
-- Name: account_charts; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.account_charts (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(200) NOT NULL,
    name_en character varying(200),
    account_type character varying(20) NOT NULL,
    parent_id integer,
    level integer,
    normal_balance character varying(10),
    is_detail boolean,
    is_active boolean,
    description text,
    created_at timestamp without time zone
);


ALTER TABLE public.account_charts OWNER TO bamboo;

--
-- TOC entry 220 (class 1259 OID 68064)
-- Name: account_charts_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.account_charts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_charts_id_seq OWNER TO bamboo;

--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 220
-- Name: account_charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.account_charts_id_seq OWNED BY public.account_charts.id;


--
-- TOC entry 283 (class 1259 OID 111845)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO bamboo;

--
-- TOC entry 264 (class 1259 OID 99776)
-- Name: cart; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.cart (
    id integer NOT NULL,
    session_id integer NOT NULL,
    customer_id integer,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cart OWNER TO bamboo;

--
-- TOC entry 263 (class 1259 OID 99774)
-- Name: cart_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_id_seq OWNER TO bamboo;

--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 263
-- Name: cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;


--
-- TOC entry 266 (class 1259 OID 99797)
-- Name: cart_items; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.cart_items (
    id integer NOT NULL,
    cart_id integer NOT NULL,
    listing_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity numeric(18,3) DEFAULT 1 NOT NULL,
    unit_price numeric(18,2) DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cart_items OWNER TO bamboo;

--
-- TOC entry 265 (class 1259 OID 99795)
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.cart_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_items_id_seq OWNER TO bamboo;

--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 265
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- TOC entry 213 (class 1259 OID 68012)
-- Name: categories; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    code character varying(30) NOT NULL,
    name character varying(120) NOT NULL,
    parent_id integer,
    description character varying(300),
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.categories OWNER TO bamboo;

--
-- TOC entry 212 (class 1259 OID 68010)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO bamboo;

--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 212
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- TOC entry 276 (class 1259 OID 99943)
-- Name: customer_accounts; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.customer_accounts (
    id integer NOT NULL,
    customer_id integer,
    email character varying(120) NOT NULL,
    password_hash character varying(255) NOT NULL,
    name character varying(200) NOT NULL,
    phone character varying(50),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login timestamp without time zone,
    role character varying(50) DEFAULT 'web_customer'::character varying
);


ALTER TABLE public.customer_accounts OWNER TO bamboo;

--
-- TOC entry 275 (class 1259 OID 99941)
-- Name: customer_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.customer_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_accounts_id_seq OWNER TO bamboo;

--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 275
-- Name: customer_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.customer_accounts_id_seq OWNED BY public.customer_accounts.id;


--
-- TOC entry 262 (class 1259 OID 99756)
-- Name: customer_sessions; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.customer_sessions (
    id integer NOT NULL,
    session_key character varying(120) NOT NULL,
    customer_id integer,
    name character varying(200),
    email character varying(120),
    phone character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_seen_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp without time zone
);


ALTER TABLE public.customer_sessions OWNER TO bamboo;

--
-- TOC entry 261 (class 1259 OID 99754)
-- Name: customer_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.customer_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_sessions_id_seq OWNER TO bamboo;

--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 261
-- Name: customer_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.customer_sessions_id_seq OWNED BY public.customer_sessions.id;


--
-- TOC entry 217 (class 1259 OID 68040)
-- Name: customers; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    short_name character varying(100),
    customer_type character varying(20),
    address character varying(300),
    phone character varying(20),
    email character varying(120),
    tax_code character varying(20),
    contact_person character varying(100),
    bank_account character varying(30),
    bank_name character varying(100),
    bank_branch character varying(100),
    payment_terms integer,
    credit_limit numeric(18,2),
    discount_rate numeric(5,2),
    note text,
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.customers OWNER TO bamboo;

--
-- TOC entry 216 (class 1259 OID 68038)
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_id_seq OWNER TO bamboo;

--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 216
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 235 (class 1259 OID 68213)
-- Name: debt_payments; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.debt_payments (
    id integer NOT NULL,
    debt_id integer NOT NULL,
    date date NOT NULL,
    amount numeric(18,2) NOT NULL,
    payment_method character varying(30),
    reference character varying(100),
    note character varying(200),
    created_by integer,
    created_at timestamp without time zone
);


ALTER TABLE public.debt_payments OWNER TO bamboo;

--
-- TOC entry 234 (class 1259 OID 68211)
-- Name: debt_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.debt_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.debt_payments_id_seq OWNER TO bamboo;

--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 234
-- Name: debt_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.debt_payments_id_seq OWNED BY public.debt_payments.id;


--
-- TOC entry 223 (class 1259 OID 68084)
-- Name: debts; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.debts (
    id integer NOT NULL,
    partner_type character varying(20) NOT NULL,
    partner_id integer NOT NULL,
    reference_type character varying(50),
    reference_id integer,
    reference_code character varying(50),
    date date NOT NULL,
    due_date date,
    amount numeric(18,2) NOT NULL,
    paid_amount numeric(18,2),
    balance numeric(18,2) NOT NULL,
    currency character varying(5),
    status character varying(20),
    note text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.debts OWNER TO bamboo;

--
-- TOC entry 222 (class 1259 OID 68082)
-- Name: debts_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.debts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.debts_id_seq OWNER TO bamboo;

--
-- TOC entry 3530 (class 0 OID 0)
-- Dependencies: 222
-- Name: debts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.debts_id_seq OWNED BY public.debts.id;


--
-- TOC entry 285 (class 1259 OID 111854)
-- Name: erp_users; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.erp_users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(255),
    role character varying(50),
    is_active boolean,
    last_login timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.erp_users OWNER TO bamboo;

--
-- TOC entry 284 (class 1259 OID 111852)
-- Name: erp_users_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.erp_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.erp_users_id_seq OWNER TO bamboo;

--
-- TOC entry 3531 (class 0 OID 0)
-- Dependencies: 284
-- Name: erp_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.erp_users_id_seq OWNED BY public.erp_users.id;


--
-- TOC entry 243 (class 1259 OID 68290)
-- Name: inventory; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.inventory (
    id integer NOT NULL,
    product_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    quantity numeric(18,3),
    avg_cost numeric(18,2),
    last_updated timestamp without time zone
);


ALTER TABLE public.inventory OWNER TO bamboo;

--
-- TOC entry 245 (class 1259 OID 68310)
-- Name: inventory_history; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.inventory_history (
    id integer NOT NULL,
    product_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    transaction_type character varying(20) NOT NULL,
    reference_code character varying(50),
    quantity_change numeric(18,3) NOT NULL,
    quantity_before numeric(18,3),
    quantity_after numeric(18,3),
    unit_cost numeric(18,2),
    note character varying(200),
    created_at timestamp without time zone,
    created_by integer
);


ALTER TABLE public.inventory_history OWNER TO bamboo;

--
-- TOC entry 244 (class 1259 OID 68308)
-- Name: inventory_history_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.inventory_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_history_id_seq OWNER TO bamboo;

--
-- TOC entry 3532 (class 0 OID 0)
-- Dependencies: 244
-- Name: inventory_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.inventory_history_id_seq OWNED BY public.inventory_history.id;


--
-- TOC entry 242 (class 1259 OID 68288)
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.inventory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventory_id_seq OWNER TO bamboo;

--
-- TOC entry 3533 (class 0 OID 0)
-- Dependencies: 242
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- TOC entry 233 (class 1259 OID 68195)
-- Name: journal_entries; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.journal_entries (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    date date NOT NULL,
    description character varying(300) NOT NULL,
    reference_type character varying(50),
    reference_id integer,
    reference_code character varying(50),
    total_debit numeric(18,2),
    total_credit numeric(18,2),
    status character varying(20),
    note text,
    created_by integer,
    created_at timestamp without time zone
);


ALTER TABLE public.journal_entries OWNER TO bamboo;

--
-- TOC entry 232 (class 1259 OID 68193)
-- Name: journal_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.journal_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.journal_entries_id_seq OWNER TO bamboo;

--
-- TOC entry 3534 (class 0 OID 0)
-- Dependencies: 232
-- Name: journal_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.journal_entries_id_seq OWNED BY public.journal_entries.id;


--
-- TOC entry 247 (class 1259 OID 68333)
-- Name: journal_lines; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.journal_lines (
    id integer NOT NULL,
    entry_id integer NOT NULL,
    account_id integer NOT NULL,
    description character varying(300),
    debit numeric(18,2),
    credit numeric(18,2),
    partner_type character varying(20),
    partner_id integer,
    order_no integer
);


ALTER TABLE public.journal_lines OWNER TO bamboo;

--
-- TOC entry 246 (class 1259 OID 68331)
-- Name: journal_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.journal_lines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.journal_lines_id_seq OWNER TO bamboo;

--
-- TOC entry 3535 (class 0 OID 0)
-- Dependencies: 246
-- Name: journal_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.journal_lines_id_seq OWNED BY public.journal_lines.id;


--
-- TOC entry 248 (class 1259 OID 68372)
-- Name: menu_roles; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.menu_roles (
    menu_id integer NOT NULL,
    role character varying(30) NOT NULL
);


ALTER TABLE public.menu_roles OWNER TO bamboo;

--
-- TOC entry 203 (class 1259 OID 67943)
-- Name: menus; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.menus (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    parent_id integer,
    url character varying(200),
    icon character varying(100),
    order_no integer,
    module character varying(50),
    roles character varying(200),
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.menus OWNER TO bamboo;

--
-- TOC entry 3536 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.code; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.code IS 'Mã menu';


--
-- TOC entry 3537 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.name; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.name IS 'Tên menu';


--
-- TOC entry 3538 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.parent_id; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.parent_id IS 'Menu cha';


--
-- TOC entry 3539 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.url; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.url IS 'Đường dẫn URL';


--
-- TOC entry 3540 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.icon; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.icon IS 'Icon FontAwesome';


--
-- TOC entry 3541 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.order_no; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.order_no IS 'Thứ tự hiển thị';


--
-- TOC entry 3542 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.module; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.module IS 'Module chức năng';


--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.roles; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.roles IS 'Quyền truy cập (CSV, legacy)';


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.is_active; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.is_active IS 'Kích hoạt';


--
-- TOC entry 202 (class 1259 OID 67941)
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.menus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menus_id_seq OWNER TO bamboo;

--
-- TOC entry 3545 (class 0 OID 0)
-- Dependencies: 202
-- Name: menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.menus_id_seq OWNED BY public.menus.id;


--
-- TOC entry 253 (class 1259 OID 78232)
-- Name: mv_account_daily_balance; Type: MATERIALIZED VIEW; Schema: public; Owner: bamboo
--

CREATE MATERIALIZED VIEW public.mv_account_daily_balance AS
 SELECT ac.code,
    je.date AS balance_date,
    sum(
        CASE
            WHEN ((ac.normal_balance)::text = 'debit'::text) THEN (jl.debit - jl.credit)
            ELSE (jl.credit - jl.debit)
        END) AS daily_change
   FROM ((public.account_charts ac
     JOIN public.journal_lines jl ON ((ac.id = jl.account_id)))
     JOIN public.journal_entries je ON (((jl.entry_id = je.id) AND ((je.status)::text = 'posted'::text))))
  WHERE (ac.is_active = true)
  GROUP BY ac.code, je.date
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.mv_account_daily_balance OWNER TO bamboo;

--
-- TOC entry 205 (class 1259 OID 67961)
-- Name: notifications; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    message_template text NOT NULL,
    noti_type character varying(20),
    module character varying(50),
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.notifications OWNER TO bamboo;

--
-- TOC entry 3546 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.code; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.code IS 'Mã thông báo';


--
-- TOC entry 3547 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.name; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.name IS 'Tên thông báo';


--
-- TOC entry 3548 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.message_template; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.message_template IS 'Mẫu nội dung thông báo';


--
-- TOC entry 3549 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.noti_type; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.noti_type IS 'Loại: success/error/warning/info';


--
-- TOC entry 3550 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.module; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.module IS 'Module áp dụng';


--
-- TOC entry 204 (class 1259 OID 67959)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO bamboo;

--
-- TOC entry 3551 (class 0 OID 0)
-- Dependencies: 204
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 274 (class 1259 OID 99914)
-- Name: online_order_items; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.online_order_items (
    id integer NOT NULL,
    online_order_id integer NOT NULL,
    listing_id integer,
    product_id integer NOT NULL,
    product_name_snapshot character varying(250),
    quantity numeric(18,3) NOT NULL,
    unit_price numeric(18,2) NOT NULL,
    amount numeric(18,2) DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.online_order_items OWNER TO bamboo;

--
-- TOC entry 273 (class 1259 OID 99912)
-- Name: online_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.online_order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.online_order_items_id_seq OWNER TO bamboo;

--
-- TOC entry 3552 (class 0 OID 0)
-- Dependencies: 273
-- Name: online_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.online_order_items_id_seq OWNED BY public.online_order_items.id;


--
-- TOC entry 272 (class 1259 OID 99872)
-- Name: online_orders; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.online_orders (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    session_id integer,
    customer_id integer,
    promotion_id integer,
    customer_name character varying(200) NOT NULL,
    customer_phone character varying(50),
    customer_email character varying(120),
    shipping_address character varying(500),
    subtotal numeric(18,2) DEFAULT 0,
    discount_amount numeric(18,2) DEFAULT 0,
    shipping_fee numeric(18,2) DEFAULT 0,
    vat_amount numeric(18,2) DEFAULT 0,
    total_amount numeric(18,2) DEFAULT 0,
    status character varying(20) DEFAULT 'new'::character varying,
    sync_status character varying(20) DEFAULT 'pending'::character varying,
    sync_error text,
    stock_out_id integer,
    note text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    synced_at timestamp without time zone,
    erp_status character varying(20),
    erp_note text,
    web_customer_id integer,
    payment_method character varying(20)
);


ALTER TABLE public.online_orders OWNER TO bamboo;

--
-- TOC entry 3553 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN online_orders.erp_status; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.online_orders.erp_status IS 'Trạng thái bản ghi xuất kho ERP';


--
-- TOC entry 3554 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN online_orders.erp_note; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.online_orders.erp_note IS 'Ghi chú cập nhật từ ERP';


--
-- TOC entry 271 (class 1259 OID 99870)
-- Name: online_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.online_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.online_orders_id_seq OWNER TO bamboo;

--
-- TOC entry 3555 (class 0 OID 0)
-- Dependencies: 271
-- Name: online_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.online_orders_id_seq OWNED BY public.online_orders.id;


--
-- TOC entry 237 (class 1259 OID 68231)
-- Name: opening_stocks; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.opening_stocks (
    id integer NOT NULL,
    period_date date NOT NULL,
    product_id integer NOT NULL,
    warehouse_id integer NOT NULL,
    quantity numeric(18,3),
    unit_cost numeric(18,2),
    amount numeric(18,2),
    note character varying(200),
    is_posted boolean,
    created_by integer,
    created_at timestamp without time zone
);


ALTER TABLE public.opening_stocks OWNER TO bamboo;

--
-- TOC entry 236 (class 1259 OID 68229)
-- Name: opening_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.opening_stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.opening_stocks_id_seq OWNER TO bamboo;

--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 236
-- Name: opening_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.opening_stocks_id_seq OWNED BY public.opening_stocks.id;


--
-- TOC entry 278 (class 1259 OID 102052)
-- Name: product_images; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.product_images (
    id integer NOT NULL,
    product_id integer NOT NULL,
    image_url character varying(500) NOT NULL,
    image_name character varying(255),
    sort_order integer DEFAULT 0,
    is_main boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.product_images OWNER TO bamboo;

--
-- TOC entry 277 (class 1259 OID 102050)
-- Name: product_images_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

ALTER TABLE public.product_images ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.product_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 260 (class 1259 OID 99732)
-- Name: product_listings; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.product_listings (
    id integer NOT NULL,
    product_id integer NOT NULL,
    slug character varying(220) NOT NULL,
    web_title character varying(220),
    web_description text,
    web_price numeric(18,2),
    compare_at_price numeric(18,2),
    image_url character varying(500),
    seo_title character varying(220),
    seo_description character varying(300),
    stock_cached numeric(18,3) DEFAULT 0,
    stock_synced_at timestamp without time zone,
    is_published boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    retail_price numeric(18,2),
    contact_for_price boolean DEFAULT false
);


ALTER TABLE public.product_listings OWNER TO bamboo;

--
-- TOC entry 259 (class 1259 OID 99730)
-- Name: product_listings_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.product_listings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_listings_id_seq OWNER TO bamboo;

--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 259
-- Name: product_listings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.product_listings_id_seq OWNED BY public.product_listings.id;


--
-- TOC entry 227 (class 1259 OID 68106)
-- Name: products; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.products (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    barcode character varying(60),
    name character varying(200) NOT NULL,
    name_en character varying(200),
    unit_id integer,
    unit character varying(30) NOT NULL,
    category_id integer,
    category character varying(100),
    purchase_price numeric(18,2),
    sale_price numeric(18,2),
    vat_rate numeric(5,2),
    min_stock numeric(18,3),
    max_stock numeric(18,3),
    allow_negative boolean,
    description text,
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    retail_price numeric(18,2)
);


ALTER TABLE public.products OWNER TO bamboo;

--
-- TOC entry 226 (class 1259 OID 68104)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO bamboo;

--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 226
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- TOC entry 268 (class 1259 OID 99824)
-- Name: promotions; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.promotions (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    discount_type character varying(20) DEFAULT 'percent'::character varying,
    discount_value numeric(18,2) DEFAULT 0,
    min_order_amount numeric(18,2) DEFAULT 0,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.promotions OWNER TO bamboo;

--
-- TOC entry 267 (class 1259 OID 99822)
-- Name: promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.promotions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotions_id_seq OWNER TO bamboo;

--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 267
-- Name: promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.promotions_id_seq OWNED BY public.promotions.id;


--
-- TOC entry 258 (class 1259 OID 91589)
-- Name: quotation_items; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.quotation_items (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    product_id integer NOT NULL,
    unit_id integer,
    conversion_factor numeric(12,4) DEFAULT 1,
    quantity numeric(18,3) NOT NULL,
    unit_price numeric(18,2) NOT NULL,
    vat_rate numeric(5,2) DEFAULT 10,
    vat_amount numeric(18,2) DEFAULT 0,
    amount numeric(18,2) DEFAULT 0,
    total_amount numeric(18,2) DEFAULT 0,
    note character varying(200)
);


ALTER TABLE public.quotation_items OWNER TO bamboo;

--
-- TOC entry 257 (class 1259 OID 91587)
-- Name: quotation_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.quotation_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quotation_items_id_seq OWNER TO bamboo;

--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 257
-- Name: quotation_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.quotation_items_id_seq OWNED BY public.quotation_items.id;


--
-- TOC entry 256 (class 1259 OID 91552)
-- Name: quotations; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.quotations (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    date date NOT NULL,
    valid_until date,
    customer_id integer,
    subtotal numeric(18,2) DEFAULT 0,
    discount_amount numeric(18,2) DEFAULT 0,
    vat_amount numeric(18,2) DEFAULT 0,
    total_amount numeric(18,2) DEFAULT 0,
    vat_mode character varying(20) DEFAULT 'grouped'::character varying,
    vat_rate_grouped numeric(5,2) DEFAULT 0,
    status character varying(20) DEFAULT 'draft'::character varying,
    note text,
    terms text,
    stock_out_id integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    recipient_name character varying(200),
    recipient_address character varying(300),
    recipient_phone character varying(50),
    recipient_email character varying(120)
);


ALTER TABLE public.quotations OWNER TO bamboo;

--
-- TOC entry 255 (class 1259 OID 91550)
-- Name: quotations_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.quotations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quotations_id_seq OWNER TO bamboo;

--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 255
-- Name: quotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.quotations_id_seq OWNED BY public.quotations.id;


--
-- TOC entry 270 (class 1259 OID 99843)
-- Name: reviews; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    listing_id integer NOT NULL,
    product_id integer NOT NULL,
    customer_id integer,
    customer_name character varying(200),
    rating integer DEFAULT 5 NOT NULL,
    title character varying(200),
    content text,
    status character varying(20) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.reviews OWNER TO bamboo;

--
-- TOC entry 269 (class 1259 OID 99841)
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO bamboo;

--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 269
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- TOC entry 239 (class 1259 OID 68254)
-- Name: stock_in_items; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.stock_in_items (
    id integer NOT NULL,
    stock_in_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity numeric(18,3) NOT NULL,
    unit_price numeric(18,2) NOT NULL,
    vat_rate numeric(5,2),
    vat_amount numeric(18,2),
    amount numeric(18,2),
    total_amount numeric(18,2),
    note character varying(200),
    unit_id integer,
    conversion_factor numeric(12,4) DEFAULT 1.0
);


ALTER TABLE public.stock_in_items OWNER TO bamboo;

--
-- TOC entry 238 (class 1259 OID 68252)
-- Name: stock_in_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.stock_in_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_in_items_id_seq OWNER TO bamboo;

--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 238
-- Name: stock_in_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.stock_in_items_id_seq OWNED BY public.stock_in_items.id;


--
-- TOC entry 229 (class 1259 OID 68129)
-- Name: stock_ins; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.stock_ins (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    date date NOT NULL,
    supplier_id integer,
    warehouse_id integer NOT NULL,
    invoice_no character varying(50),
    invoice_series character varying(10),
    invoice_date date,
    reference character varying(100),
    subtotal numeric(18,2),
    discount_pct numeric(5,2),
    discount_amount numeric(18,2),
    vat_amount numeric(18,2),
    total_amount numeric(18,2),
    paid_amount numeric(18,2),
    vat_manual boolean,
    vat_manual_val numeric(18,2),
    status character varying(20),
    note text,
    created_by integer,
    confirmed_by integer,
    confirmed_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    unit_id integer,
    conversion_factor numeric(12,4) DEFAULT 1.0
);


ALTER TABLE public.stock_ins OWNER TO bamboo;

--
-- TOC entry 228 (class 1259 OID 68127)
-- Name: stock_ins_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.stock_ins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_ins_id_seq OWNER TO bamboo;

--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 228
-- Name: stock_ins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.stock_ins_id_seq OWNED BY public.stock_ins.id;


--
-- TOC entry 241 (class 1259 OID 68272)
-- Name: stock_out_items; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.stock_out_items (
    id integer NOT NULL,
    stock_out_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity numeric(18,3) NOT NULL,
    unit_price numeric(18,2) NOT NULL,
    cost_price numeric(18,2),
    vat_rate numeric(5,2),
    vat_amount numeric(18,2),
    amount numeric(18,2),
    total_amount numeric(18,2),
    note character varying(200),
    unit_id integer,
    conversion_factor numeric(12,4) DEFAULT 1.0,
    box_note character varying(100)
);


ALTER TABLE public.stock_out_items OWNER TO bamboo;

--
-- TOC entry 240 (class 1259 OID 68270)
-- Name: stock_out_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.stock_out_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_out_items_id_seq OWNER TO bamboo;

--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 240
-- Name: stock_out_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.stock_out_items_id_seq OWNED BY public.stock_out_items.id;


--
-- TOC entry 231 (class 1259 OID 68162)
-- Name: stock_outs; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.stock_outs (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    date date NOT NULL,
    customer_id integer,
    warehouse_id integer NOT NULL,
    invoice_no character varying(50),
    invoice_series character varying(10),
    reference character varying(100),
    subtotal numeric(18,2),
    discount_pct numeric(5,2),
    discount_amount numeric(18,2),
    vat_amount numeric(18,2),
    total_amount numeric(18,2),
    paid_amount numeric(18,2),
    vat_manual boolean,
    vat_manual_val numeric(18,2),
    status character varying(20),
    note text,
    created_by integer,
    confirmed_by integer,
    confirmed_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    unit_id integer,
    conversion_factor numeric(12,4) DEFAULT 1.0,
    vat_mode character varying(20) DEFAULT 'per_item'::character varying,
    vat_rate_grouped numeric(5,2) DEFAULT 0
);


ALTER TABLE public.stock_outs OWNER TO bamboo;

--
-- TOC entry 230 (class 1259 OID 68160)
-- Name: stock_outs_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.stock_outs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_outs_id_seq OWNER TO bamboo;

--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 230
-- Name: stock_outs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.stock_outs_id_seq OWNED BY public.stock_outs.id;


--
-- TOC entry 282 (class 1259 OID 111823)
-- Name: stocktaking_items; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.stocktaking_items (
    id integer NOT NULL,
    stocktaking_id integer NOT NULL,
    product_id integer NOT NULL,
    book_quantity numeric(18,3),
    actual_quantity numeric(18,3),
    difference numeric(18,3),
    note character varying(200),
    is_adjusted boolean
);


ALTER TABLE public.stocktaking_items OWNER TO bamboo;

--
-- TOC entry 281 (class 1259 OID 111821)
-- Name: stocktaking_items_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.stocktaking_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stocktaking_items_id_seq OWNER TO bamboo;

--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 281
-- Name: stocktaking_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.stocktaking_items_id_seq OWNED BY public.stocktaking_items.id;


--
-- TOC entry 280 (class 1259 OID 111792)
-- Name: stocktakings; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.stocktakings (
    id integer NOT NULL,
    warehouse_id integer NOT NULL,
    count_date date NOT NULL,
    status character varying(20),
    note text,
    created_by integer,
    completed_by integer,
    completed_at timestamp without time zone,
    cancelled_by integer,
    cancelled_at timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.stocktakings OWNER TO bamboo;

--
-- TOC entry 279 (class 1259 OID 111790)
-- Name: stocktakings_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.stocktakings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stocktakings_id_seq OWNER TO bamboo;

--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 279
-- Name: stocktakings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.stocktakings_id_seq OWNED BY public.stocktakings.id;


--
-- TOC entry 215 (class 1259 OID 68027)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    short_name character varying(100),
    address character varying(300),
    phone character varying(20),
    fax character varying(20),
    email character varying(120),
    website character varying(200),
    tax_code character varying(20),
    contact_person character varying(100),
    bank_account character varying(30),
    bank_name character varying(100),
    bank_branch character varying(100),
    payment_terms integer,
    credit_limit numeric(18,2),
    note text,
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.suppliers OWNER TO bamboo;

--
-- TOC entry 214 (class 1259 OID 68025)
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_id_seq OWNER TO bamboo;

--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 214
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- TOC entry 209 (class 1259 OID 67989)
-- Name: system_configs; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.system_configs (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    description character varying(200),
    group_name character varying(50),
    updated_at timestamp without time zone
);


ALTER TABLE public.system_configs OWNER TO bamboo;

--
-- TOC entry 208 (class 1259 OID 67987)
-- Name: system_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.system_configs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_configs_id_seq OWNER TO bamboo;

--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 208
-- Name: system_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.system_configs_id_seq OWNED BY public.system_configs.id;


--
-- TOC entry 250 (class 1259 OID 69982)
-- Name: unit_conversions; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.unit_conversions (
    id integer NOT NULL,
    product_id integer NOT NULL,
    from_unit_id integer NOT NULL,
    to_unit_id integer NOT NULL,
    conversion_factor numeric(12,4) NOT NULL
);


ALTER TABLE public.unit_conversions OWNER TO bamboo;

--
-- TOC entry 249 (class 1259 OID 69980)
-- Name: unit_conversions_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.unit_conversions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unit_conversions_id_seq OWNER TO bamboo;

--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 249
-- Name: unit_conversions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.unit_conversions_id_seq OWNED BY public.unit_conversions.id;


--
-- TOC entry 211 (class 1259 OID 68002)
-- Name: units; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.units (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(60) NOT NULL,
    description character varying(200),
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.units OWNER TO bamboo;

--
-- TOC entry 210 (class 1259 OID 68000)
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.units_id_seq OWNER TO bamboo;

--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 210
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- TOC entry 254 (class 1259 OID 91522)
-- Name: user_menu_overrides; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.user_menu_overrides (
    user_id integer NOT NULL,
    menu_id integer NOT NULL,
    is_visible boolean NOT NULL
);


ALTER TABLE public.user_menu_overrides OWNER TO bamboo;

--
-- TOC entry 252 (class 1259 OID 70020)
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    module character varying(50) NOT NULL,
    can_view boolean DEFAULT false,
    can_add boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false
);


ALTER TABLE public.user_permissions OWNER TO bamboo;

--
-- TOC entry 251 (class 1259 OID 70018)
-- Name: user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_permissions_id_seq OWNER TO bamboo;

--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 251
-- Name: user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.user_permissions_id_seq OWNED BY public.user_permissions.id;


--
-- TOC entry 207 (class 1259 OID 67974)
-- Name: users; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(80) NOT NULL,
    email character varying(120) NOT NULL,
    password_hash character varying(256) NOT NULL,
    full_name character varying(100) NOT NULL,
    role character varying(20),
    is_active boolean,
    last_login timestamp without time zone,
    created_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO bamboo;

--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN users.role; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.users.role IS 'admin/user/accountant/warehouse';


--
-- TOC entry 206 (class 1259 OID 67972)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO bamboo;

--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 206
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 225 (class 1259 OID 68095)
-- Name: vat_records; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.vat_records (
    id integer NOT NULL,
    vat_type character varying(10) NOT NULL,
    date date NOT NULL,
    invoice_no character varying(50),
    invoice_series character varying(10),
    reference_type character varying(50),
    reference_id integer,
    reference_code character varying(50),
    partner_name character varying(200),
    partner_tax_code character varying(20),
    partner_address character varying(300),
    taxable_amount numeric(18,2),
    vat_rate numeric(5,2),
    vat_amount numeric(18,2),
    total_amount numeric(18,2),
    is_deductible boolean,
    period_month integer,
    period_year integer,
    note text,
    created_at timestamp without time zone
);


ALTER TABLE public.vat_records OWNER TO bamboo;

--
-- TOC entry 224 (class 1259 OID 68093)
-- Name: vat_records_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.vat_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vat_records_id_seq OWNER TO bamboo;

--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 224
-- Name: vat_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.vat_records_id_seq OWNED BY public.vat_records.id;


--
-- TOC entry 219 (class 1259 OID 68053)
-- Name: warehouses; Type: TABLE; Schema: public; Owner: bamboo
--

CREATE TABLE public.warehouses (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(300),
    manager character varying(100),
    phone character varying(20),
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.warehouses OWNER TO bamboo;

--
-- TOC entry 218 (class 1259 OID 68051)
-- Name: warehouses_id_seq; Type: SEQUENCE; Schema: public; Owner: bamboo
--

CREATE SEQUENCE public.warehouses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.warehouses_id_seq OWNER TO bamboo;

--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 218
-- Name: warehouses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.warehouses_id_seq OWNED BY public.warehouses.id;


--
-- TOC entry 2971 (class 2604 OID 68069)
-- Name: account_charts id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts ALTER COLUMN id SET DEFAULT nextval('public.account_charts_id_seq'::regclass);


--
-- TOC entry 3022 (class 2604 OID 99779)
-- Name: cart id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);


--
-- TOC entry 3026 (class 2604 OID 99800)
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- TOC entry 2967 (class 2604 OID 68015)
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- TOC entry 3055 (class 2604 OID 99946)
-- Name: customer_accounts id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_accounts ALTER COLUMN id SET DEFAULT nextval('public.customer_accounts_id_seq'::regclass);


--
-- TOC entry 3019 (class 2604 OID 99759)
-- Name: customer_sessions id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_sessions ALTER COLUMN id SET DEFAULT nextval('public.customer_sessions_id_seq'::regclass);


--
-- TOC entry 2969 (class 2604 OID 68043)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 2982 (class 2604 OID 68216)
-- Name: debt_payments id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments ALTER COLUMN id SET DEFAULT nextval('public.debt_payments_id_seq'::regclass);


--
-- TOC entry 2972 (class 2604 OID 68087)
-- Name: debts id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debts ALTER COLUMN id SET DEFAULT nextval('public.debts_id_seq'::regclass);


--
-- TOC entry 3064 (class 2604 OID 111857)
-- Name: erp_users id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.erp_users ALTER COLUMN id SET DEFAULT nextval('public.erp_users_id_seq'::regclass);


--
-- TOC entry 2988 (class 2604 OID 68293)
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- TOC entry 2989 (class 2604 OID 68313)
-- Name: inventory_history id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history ALTER COLUMN id SET DEFAULT nextval('public.inventory_history_id_seq'::regclass);


--
-- TOC entry 2981 (class 2604 OID 68198)
-- Name: journal_entries id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries ALTER COLUMN id SET DEFAULT nextval('public.journal_entries_id_seq'::regclass);


--
-- TOC entry 2990 (class 2604 OID 68336)
-- Name: journal_lines id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines ALTER COLUMN id SET DEFAULT nextval('public.journal_lines_id_seq'::regclass);


--
-- TOC entry 2962 (class 2604 OID 67946)
-- Name: menus id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus ALTER COLUMN id SET DEFAULT nextval('public.menus_id_seq'::regclass);


--
-- TOC entry 2963 (class 2604 OID 67964)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 3052 (class 2604 OID 99917)
-- Name: online_order_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_order_items ALTER COLUMN id SET DEFAULT nextval('public.online_order_items_id_seq'::regclass);


--
-- TOC entry 3042 (class 2604 OID 99875)
-- Name: online_orders id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders ALTER COLUMN id SET DEFAULT nextval('public.online_orders_id_seq'::regclass);


--
-- TOC entry 2983 (class 2604 OID 68234)
-- Name: opening_stocks id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks ALTER COLUMN id SET DEFAULT nextval('public.opening_stocks_id_seq'::regclass);


--
-- TOC entry 3013 (class 2604 OID 99735)
-- Name: product_listings id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.product_listings ALTER COLUMN id SET DEFAULT nextval('public.product_listings_id_seq'::regclass);


--
-- TOC entry 2974 (class 2604 OID 68109)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 3031 (class 2604 OID 99827)
-- Name: promotions id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.promotions ALTER COLUMN id SET DEFAULT nextval('public.promotions_id_seq'::regclass);


--
-- TOC entry 3007 (class 2604 OID 91592)
-- Name: quotation_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotation_items ALTER COLUMN id SET DEFAULT nextval('public.quotation_items_id_seq'::regclass);


--
-- TOC entry 2997 (class 2604 OID 91555)
-- Name: quotations id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotations ALTER COLUMN id SET DEFAULT nextval('public.quotations_id_seq'::regclass);


--
-- TOC entry 3038 (class 2604 OID 99846)
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- TOC entry 2984 (class 2604 OID 68257)
-- Name: stock_in_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items ALTER COLUMN id SET DEFAULT nextval('public.stock_in_items_id_seq'::regclass);


--
-- TOC entry 2975 (class 2604 OID 68132)
-- Name: stock_ins id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins ALTER COLUMN id SET DEFAULT nextval('public.stock_ins_id_seq'::regclass);


--
-- TOC entry 2986 (class 2604 OID 68275)
-- Name: stock_out_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items ALTER COLUMN id SET DEFAULT nextval('public.stock_out_items_id_seq'::regclass);


--
-- TOC entry 2977 (class 2604 OID 68165)
-- Name: stock_outs id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs ALTER COLUMN id SET DEFAULT nextval('public.stock_outs_id_seq'::regclass);


--
-- TOC entry 3063 (class 2604 OID 111826)
-- Name: stocktaking_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktaking_items ALTER COLUMN id SET DEFAULT nextval('public.stocktaking_items_id_seq'::regclass);


--
-- TOC entry 3062 (class 2604 OID 111795)
-- Name: stocktakings id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktakings ALTER COLUMN id SET DEFAULT nextval('public.stocktakings_id_seq'::regclass);


--
-- TOC entry 2968 (class 2604 OID 68030)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 2965 (class 2604 OID 67992)
-- Name: system_configs id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.system_configs ALTER COLUMN id SET DEFAULT nextval('public.system_configs_id_seq'::regclass);


--
-- TOC entry 2991 (class 2604 OID 69985)
-- Name: unit_conversions id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions ALTER COLUMN id SET DEFAULT nextval('public.unit_conversions_id_seq'::regclass);


--
-- TOC entry 2966 (class 2604 OID 68005)
-- Name: units id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- TOC entry 2992 (class 2604 OID 70023)
-- Name: user_permissions id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions ALTER COLUMN id SET DEFAULT nextval('public.user_permissions_id_seq'::regclass);


--
-- TOC entry 2964 (class 2604 OID 67977)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 2973 (class 2604 OID 68098)
-- Name: vat_records id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.vat_records ALTER COLUMN id SET DEFAULT nextval('public.vat_records_id_seq'::regclass);


--
-- TOC entry 2970 (class 2604 OID 68056)
-- Name: warehouses id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.warehouses ALTER COLUMN id SET DEFAULT nextval('public.warehouses_id_seq'::regclass);


--
-- TOC entry 3451 (class 0 OID 68066)
-- Dependencies: 221
-- Data for Name: account_charts; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.account_charts (id, code, name, name_en, account_type, parent_id, level, normal_balance, is_detail, is_active, description, created_at) FROM stdin;
1	1	Tiền và các khoản tương đương tiền		asset	\N	1	debit	f	t		2026-04-09 09:51:46.49613
2	11	Tiền mặt		asset	1	2	debit	f	t		2026-04-09 09:51:46.49613
3	111	Tiền mặt		asset	2	3	debit	t	t	TT99: Đổi tên từ "Tiền Việt Nam"	2026-04-09 09:51:46.49613
5	113	Tiền đang chuyển		asset	2	3	debit	t	t		2026-04-09 09:51:46.49613
6	12	Đầu tư tài chính ngắn hạn		asset	1	2	debit	f	t		2026-04-09 09:51:46.49613
7	121	Chứng khoán kinh doanh		asset	6	3	debit	t	t		2026-04-09 09:51:46.49613
8	128	Đầu tư nắm giữ đến ngày đáo hạn		asset	6	3	debit	f	t		2026-04-09 09:51:46.49613
9	1281	Tiền gửi có kỳ hạn		asset	8	4	debit	t	t	TT99: Khuyến nghị dùng Dimension investment_type	2026-04-09 09:51:46.49613
10	13	Các khoản phải thu		asset	1	2	debit	f	t		2026-04-09 09:51:46.49613
11	131	Phải thu khách hàng		asset	10	3	debit	f	t	TT99: Chuẩn hóa tên từ "Phải thu của khách hàng"	2026-04-09 09:51:46.49613
12	1311	Phải thu khách hàng trong nước		asset	11	4	debit	t	t	TT99: Rule=direct. Dùng Dimension partner_region=Domestic	2026-04-09 09:51:46.49613
13	1312	Phải thu khách hàng nước ngoài		asset	11	4	debit	t	t	TT99: Rule=direct. Dùng Dimension partner_region=Foreign	2026-04-09 09:51:46.49613
14	133	Thuế GTGT được khấu trừ		asset	10	3	debit	f	t		2026-04-09 09:51:46.49613
15	1331	Thuế GTGT được khấu trừ của hàng hóa, dịch vụ		asset	14	4	debit	t	t		2026-04-09 09:51:46.49613
16	1332	Thuế GTGT được khấu trừ của TSCĐ		asset	14	4	debit	t	t		2026-04-09 09:51:46.49613
17	136	Phải thu nội bộ		asset	10	3	debit	t	t		2026-04-09 09:51:46.49613
18	138	Phải thu khác		asset	10	3	debit	t	t		2026-04-09 09:51:46.49613
19	14	Tạm ứng		asset	1	2	debit	t	t		2026-04-09 09:51:46.49613
20	141	Tạm ứng		asset	19	3	debit	t	t		2026-04-09 09:51:46.49613
21	15	Hàng tồn kho		asset	1	2	debit	f	t		2026-04-09 09:51:46.49613
22	151	Hàng mua đang đi đường		asset	21	3	debit	t	t		2026-04-09 09:51:46.49613
23	152	Nguyên liệu, vật liệu		asset	21	3	debit	t	t		2026-04-09 09:51:46.49613
24	153	Công cụ, dụng cụ		asset	21	3	debit	t	t		2026-04-09 09:51:46.49613
25	154	Chi phí sản xuất kinh doanh dở dang		asset	21	3	debit	t	t		2026-04-09 09:51:46.49613
26	155	Sản phẩm		asset	21	3	debit	t	t	TT99: Đổi tên từ "Thành phẩm"	2026-04-09 09:51:46.49613
27	156	Hàng hóa		asset	21	3	debit	f	t		2026-04-09 09:51:46.49613
28	1561	Giá mua hàng hóa		asset	27	4	debit	t	t	TT99: Rule=direct. Dùng Dimension inventory_component=Cost	2026-04-09 09:51:46.49613
29	1562	Chi phí thu mua hàng hóa		asset	27	4	debit	t	t		2026-04-09 09:51:46.49613
30	157	Hàng gửi đi bán		asset	21	3	debit	t	t		2026-04-09 09:51:46.49613
31	158	Hàng hóa kho bảo thuế		asset	21	3	debit	t	t		2026-04-09 09:51:46.49613
32	16	Tài sản ngắn hạn khác		asset	1	2	debit	f	t		2026-04-09 09:51:46.49613
33	161	Chi sự nghiệp		asset	32	3	debit	t	t		2026-04-09 09:51:46.49613
34	2	Tài sản dài hạn		asset	\N	1	debit	f	t		2026-04-09 09:51:46.49613
35	21	Tài sản cố định		asset	34	2	debit	f	t		2026-04-09 09:51:46.49613
36	211	Tài sản cố định hữu hình		asset	35	3	debit	t	t		2026-04-09 09:51:46.49613
37	212	Tài sản cố định thuê tài chính		asset	35	3	debit	t	t		2026-04-09 09:51:46.49613
38	213	Tài sản cố định vô hình		asset	35	3	debit	t	t		2026-04-09 09:51:46.49613
39	214	Hao mòn tài sản cố định		asset	35	3	credit	t	t		2026-04-09 09:51:46.49613
40	22	Bất động sản đầu tư		asset	34	2	debit	f	t		2026-04-09 09:51:46.49613
41	228	Đầu tư góp vốn vào đơn vị khác		asset	40	2	debit	t	t		2026-04-09 09:51:46.49613
42	24	Xây dựng cơ bản dở dang		asset	34	2	debit	t	t	TT99: Sửa lỗi nhầm tên "Bất động sản đầu tư" trong CSV gốc	2026-04-09 09:51:46.49613
43	3	Nợ phải trả		liability	\N	1	credit	f	t		2026-04-09 09:51:46.49613
44	31	Nợ ngắn hạn		liability	43	2	credit	f	t		2026-04-09 09:51:46.49613
45	311	Vay và nợ thuê tài chính ngắn hạn		liability	44	3	credit	t	t		2026-04-09 09:51:46.49613
47	3311	Phải trả người bán trong nước		liability	46	4	credit	t	t	TT99: Rule=direct. Dùng Dimension vendor_region=Domestic	2026-04-09 09:51:46.49613
48	3312	Phải trả người bán nước ngoài		liability	46	4	credit	t	t	TT99: Rule=direct. Dùng Dimension vendor_region=Foreign	2026-04-09 09:51:46.49613
49	333	Thuế và các khoản phải nộp nhà nước		liability	104	3	credit	f	t	TT99: Chuẩn hóa chữ hoa/thường	2026-04-09 09:51:46.49613
50	3331	Thuế GTGT phải nộp		liability	49	4	credit	f	t		2026-04-09 09:51:46.49613
51	33311	Thuế GTGT đầu ra		liability	50	5	credit	t	t		2026-04-09 09:51:46.49613
52	33312	Thuế GTGT hàng nhập khẩu		liability	50	5	credit	t	t		2026-04-09 09:51:46.49613
53	3332	Thuế tiêu thụ đặc biệt		liability	49	4	credit	t	t		2026-04-09 09:51:46.49613
54	3333	Thuế xuất khẩu, nhập khẩu		liability	49	4	credit	t	t		2026-04-09 09:51:46.49613
55	3334	Thuế thu nhập doanh nghiệp		liability	49	4	credit	t	t		2026-04-09 09:51:46.49613
56	3335	Thuế thu nhập cá nhân		liability	49	4	credit	t	t		2026-04-09 09:51:46.49613
57	334	Phải trả người lao động		liability	104	3	credit	t	t		2026-04-09 09:51:46.49613
58	335	Chi phí phải trả		liability	104	3	credit	t	t		2026-04-09 09:51:46.49613
59	336	Phải trả nội bộ		liability	104	3	credit	t	t		2026-04-09 09:51:46.49613
60	338	Phải trả, phải nộp khác		liability	104	3	credit	t	t		2026-04-09 09:51:46.49613
61	341	Vay và nợ thuê tài chính dài hạn		liability	\N	3	credit	t	t		2026-04-09 09:51:46.49613
62	343	Trái phiếu phát hành		liability	\N	3	credit	t	t		2026-04-09 09:51:46.49613
63	4	Vốn chủ sở hữu		equity	\N	1	credit	f	t		2026-04-09 09:51:46.49613
64	41	Vốn chủ sở hữu		equity	63	2	credit	f	t		2026-04-09 09:51:46.49613
65	411	Vốn đầu tư của chủ sở hữu		equity	64	3	credit	t	t		2026-04-09 09:51:46.49613
66	412	Chênh lệch đánh giá lại tài sản		equity	64	3	credit	t	t		2026-04-09 09:51:46.49613
67	413	Chênh lệch tỷ giá hối đoái		equity	64	3	credit	t	t		2026-04-09 09:51:46.49613
68	414	Quỹ đầu tư phát triển		equity	64	3	credit	t	t		2026-04-09 09:51:46.49613
69	417	Quỹ hỗ trợ sắp xếp doanh nghiệp		equity	64	3	credit	t	t		2026-04-09 09:51:46.49613
70	418	Các quỹ khác thuộc vốn chủ sở hữu		equity	64	3	credit	t	t		2026-04-09 09:51:46.49613
46	331	Phải trả cho người bán		liability	104	3	credit	f	t	TT99: Chuẩn hóa tên từ "Phải trả cho người bán"	2026-04-09 09:51:46.49613
71	419	Cổ phiếu mua lại của chính mình		equity	64	3	debit	t	t	TT99: Đổi tên từ "Cổ phiếu quỹ"	2026-04-09 09:51:46.49613
72	421	Lợi nhuận sau thuế chưa phân phối		equity	\N	3	credit	f	t		2026-04-09 09:51:46.49613
73	4211	Lợi nhuận sau thuế năm trước		equity	72	4	credit	t	t		2026-04-09 09:51:46.49613
74	4212	Lợi nhuận sau thuế năm nay		equity	72	4	credit	t	t		2026-04-09 09:51:46.49613
75	5	Doanh thu		revenue	\N	1	credit	f	t		2026-04-09 09:51:46.49613
76	511	Doanh thu bán hàng và cung cấp dịch vụ		revenue	105	2	credit	f	t		2026-04-09 09:51:46.49613
77	5111	Doanh thu bán hàng hóa		revenue	76	3	credit	t	t	TT99: Rule=direct. Dùng Dimension revenue_type=Goods	2026-04-09 09:51:46.49613
78	5112	Doanh thu bán các thành phẩm		revenue	76	3	credit	t	t		2026-04-09 09:51:46.49613
79	5113	Doanh thu cung cấp dịch vụ		revenue	76	3	credit	t	t		2026-04-09 09:51:46.49613
80	5114	Doanh thu trợ cấp, trợ giá		revenue	76	3	credit	t	t		2026-04-09 09:51:46.49613
81	512	Doanh thu bán hàng nội bộ		revenue	105	2	credit	t	t		2026-04-09 09:51:46.49613
82	515	Doanh thu hoạt động tài chính		revenue	105	2	credit	t	t		2026-04-09 09:51:46.49613
83	521	Các khoản giảm trừ doanh thu		revenue	\N	2	debit	f	t		2026-04-09 09:51:46.49613
84	5211	Chiết khấu thương mại		revenue	83	3	debit	t	t		2026-04-09 09:51:46.49613
85	5212	Hàng bán bị trả lại		revenue	83	3	debit	t	t		2026-04-09 09:51:46.49613
86	5213	Giảm giá hàng bán		revenue	83	3	debit	t	t		2026-04-09 09:51:46.49613
87	6	Chi phí		expense	\N	1	debit	f	t		2026-04-09 09:51:46.49613
88	611	Mua hàng		expense	\N	2	debit	t	t		2026-04-09 09:51:46.49613
89	621	Chi phí nguyên liệu, vật liệu trực tiếp		expense	107	2	debit	t	t		2026-04-09 09:51:46.49613
90	622	Chi phí nhân công trực tiếp		expense	107	2	debit	t	t		2026-04-09 09:51:46.49613
91	623	Chi phí sử dụng máy thi công		expense	107	2	debit	t	t		2026-04-09 09:51:46.49613
92	627	Chi phí sản xuất chung		expense	107	2	debit	t	t		2026-04-09 09:51:46.49613
93	632	Giá vốn hàng bán		cogs	106	2	debit	t	t	TT99: Rule=direct. Mapping trực tiếp theo chuẩn COGS	2026-04-09 09:51:46.49613
94	635	Chi phí tài chính		expense	106	2	debit	t	t		2026-04-09 09:51:46.49613
95	641	Chi phí bán hàng		expense	\N	2	debit	t	t		2026-04-09 09:51:46.49613
96	642	Chi phí quản lý doanh nghiệp		expense	\N	2	debit	t	t		2026-04-09 09:51:46.49613
97	7	Thu nhập khác		other_income	\N	1	credit	f	t		2026-04-09 09:51:46.49613
98	711	Thu nhập khác		other_income	\N	2	credit	t	t		2026-04-09 09:51:46.49613
99	8	Chi phí khác		other_expense	\N	1	debit	f	t		2026-04-09 09:51:46.49613
100	811	Chi phí khác		other_expense	\N	2	debit	t	t		2026-04-09 09:51:46.49613
101	821	Chi phí thuế thu nhập doanh nghiệp		other_expense	\N	2	debit	t	t	TT99: Chuẩn hóa tên từ "Chi phí thuế TNDN"	2026-04-09 09:51:46.49613
102	9	Xác định kết quả kinh doanh		other_income	\N	1	credit	f	t		2026-04-09 09:51:46.49613
103	911	Xác định kết quả kinh doanh		other_income	\N	2	credit	t	t		2026-04-09 09:51:46.49613
104	33	Phải trả		liability	43	2	credit	f	t		2026-04-09 09:51:46.49613
105	51	Doanh thu bán hàng và cung cấp dịch vụ		revenue	75	2	credit	f	t	TT99: Gộp & chuẩn hóa tên nhóm 51	2026-04-09 09:51:46.49613
106	63	Giá vốn hàng bán		cogs	87	2	debit	t	t	TT99: Chuẩn hóa tên nhóm 63	2026-04-09 09:51:46.49613
107	62	Chi phí sản xuất		expense	87	2	debit	f	t	TT99: Chuẩn hóa tên nhóm 62	2026-04-09 09:51:46.49613
4	112	Tiền gửi không kỳ hạn		asset	2	3	debit	t	t		2026-04-09 09:51:46.49613
\.


--
-- TOC entry 3513 (class 0 OID 111845)
-- Dependencies: 283
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.alembic_version (version_num) FROM stdin;
51c6e6a1fb16
\.


--
-- TOC entry 3494 (class 0 OID 99776)
-- Dependencies: 264
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.cart (id, session_id, customer_id, status, created_at, updated_at) FROM stdin;
47	47	\N	ordered	2026-06-12 16:30:04.469784	2026-06-12 16:30:22.658015
48	48	\N	ordered	2026-06-12 16:38:33.775434	2026-06-12 16:38:45.266422
49	49	\N	ordered	2026-06-12 17:03:52.912384	2026-06-12 17:04:44.916925
50	50	\N	ordered	2026-06-18 10:33:11.334485	2026-06-18 10:33:36.449682
51	50	\N	ordered	2026-06-18 11:19:30.122634	2026-06-18 11:19:46.586457
52	51	\N	ordered	2026-06-19 15:40:54.828855	2026-06-19 15:41:15.96541
58	54	\N	ordered	2026-07-16 07:04:45.003449	2026-07-16 07:04:45.198279
59	54	\N	ordered	2026-07-16 07:06:51.033472	2026-07-16 07:06:51.118451
60	55	\N	ordered	2026-07-16 07:06:51.166778	2026-07-16 07:06:51.174692
61	54	\N	ordered	2026-07-16 08:44:42.029959	2026-07-16 08:44:50.330807
70	63	291	ordered	2026-07-16 10:18:20.282326	2026-07-16 10:18:22.403691
71	64	292	ordered	2026-07-16 10:19:28.984725	2026-07-16 10:19:31.078813
72	65	293	ordered	2026-07-16 10:21:36.741527	2026-07-16 10:21:38.842436
73	66	294	ordered	2026-07-16 10:23:20.527328	2026-07-16 10:23:22.626281
74	67	295	ordered	2026-07-16 10:24:12.641995	2026-07-16 10:24:14.742359
76	69	296	ordered	2026-07-16 10:26:25.748579	2026-07-16 10:26:27.8674
77	70	297	ordered	2026-07-16 10:27:47.711088	2026-07-16 10:27:49.853134
35	32	\N	ordered	2026-06-08 15:55:03.282352	2026-06-08 15:55:20.953977
36	38	\N	active	2026-06-12 09:46:34.734167	2026-06-12 09:46:34.734174
37	39	\N	active	2026-06-12 10:56:43.60239	2026-06-12 10:56:43.602404
38	40	\N	active	2026-06-12 14:58:55.32924	2026-06-12 14:58:55.32925
78	71	298	ordered	2026-07-16 10:29:42.357134	2026-07-16 10:29:44.458304
40	41	\N	ordered	2026-06-12 15:50:00.992987	2026-06-12 15:50:31.648568
41	41	\N	active	2026-06-12 15:58:54.558673	2026-06-12 15:58:54.558683
42	42	\N	active	2026-06-12 16:07:42.603643	2026-06-12 16:07:42.603656
43	43	\N	active	2026-06-12 16:14:04.484702	2026-06-12 16:14:04.484715
44	44	\N	active	2026-06-12 16:16:54.062733	2026-06-12 16:16:54.062739
45	45	\N	active	2026-06-12 16:18:58.835412	2026-06-12 16:18:58.835423
46	46	\N	ordered	2026-06-12 16:23:50.711895	2026-06-12 16:24:17.871934
81	54	\N	ordered	2026-07-16 11:48:46.563373	2026-07-16 11:49:39.371843
83	54	\N	ordered	2026-07-16 11:51:21.075529	2026-07-16 11:51:25.241456
85	54	\N	ordered	2026-07-16 11:54:16.738413	2026-07-16 11:54:20.926849
215	201	\N	active	2026-07-20 16:09:53.633454	2026-07-20 16:09:53.633459
94	80	\N	active	2026-07-16 12:54:24.388594	2026-07-16 12:54:24.388606
218	204	\N	active	2026-07-20 16:30:04.822864	2026-07-20 16:30:04.822881
\.


--
-- TOC entry 3496 (class 0 OID 99797)
-- Dependencies: 266
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.cart_items (id, cart_id, listing_id, product_id, quantity, unit_price, created_at, updated_at) FROM stdin;
32	35	164	436	10.000	5800.00	2026-06-08 15:55:03.290232	2026-06-08 15:55:03.290236
33	36	200	472	10.000	70000.00	2026-06-12 09:46:34.794934	2026-06-12 09:46:34.794942
35	38	200	472	1.000	70000.00	2026-06-12 14:58:55.387527	2026-06-12 14:58:55.387539
36	40	200	472	10.000	70000.00	2026-06-12 15:50:01.00536	2026-06-12 15:50:01.005372
37	41	200	472	13.000	70000.00	2026-06-12 15:58:54.567642	2026-06-12 16:06:41.969734
38	42	200	472	1.000	70000.00	2026-06-12 16:07:42.613666	2026-06-12 16:07:42.613678
39	43	200	472	1.000	70000.00	2026-06-12 16:14:04.498769	2026-06-12 16:14:04.498794
40	44	200	472	1.000	70000.00	2026-06-12 16:16:54.070432	2026-06-12 16:16:54.070437
41	45	200	472	1.000	70000.00	2026-06-12 16:18:58.851067	2026-06-12 16:18:58.851074
42	46	200	472	10.000	70000.00	2026-06-12 16:23:50.716283	2026-06-12 16:23:59.836628
43	47	200	472	10.000	70000.00	2026-06-12 16:30:04.483892	2026-06-12 16:30:04.483917
44	48	200	472	10.000	70000.00	2026-06-12 16:38:33.798924	2026-06-12 16:38:33.798935
45	49	110	388	20.000	35000.00	2026-06-12 17:03:52.920491	2026-06-12 17:03:52.920496
46	50	110	388	1.000	35000.00	2026-06-18 10:33:11.388948	2026-06-18 10:33:11.388953
47	51	110	388	10.000	35000.00	2026-06-18 11:19:30.132789	2026-06-18 11:19:30.132798
48	52	110	388	1.000	35000.00	2026-06-19 15:40:54.880192	2026-06-19 15:40:54.880198
49	58	110	388	5.000	35000.00	2026-07-16 07:04:45.023331	2026-07-16 07:04:45.091212
50	59	110	388	5.000	35000.00	2026-07-16 07:06:51.046903	2026-07-16 07:06:51.081452
51	61	110	388	5.000	35000.00	2026-07-16 08:44:42.06264	2026-07-16 08:44:44.127327
52	70	110	388	2.000	35000.00	2026-07-16 10:18:20.29866	2026-07-16 10:18:20.298666
53	71	110	388	2.000	35000.00	2026-07-16 10:19:28.99691	2026-07-16 10:19:28.99692
54	72	110	388	2.000	35000.00	2026-07-16 10:21:36.752329	2026-07-16 10:21:36.75234
55	73	110	388	2.000	35000.00	2026-07-16 10:23:20.539135	2026-07-16 10:23:20.539146
56	74	110	388	2.000	35000.00	2026-07-16 10:24:12.651106	2026-07-16 10:24:12.651115
57	76	110	388	2.000	35000.00	2026-07-16 10:26:25.76682	2026-07-16 10:26:25.766826
58	77	110	388	2.000	35000.00	2026-07-16 10:27:47.731105	2026-07-16 10:27:47.731111
59	78	110	388	1.000	35000.00	2026-07-16 10:29:42.36439	2026-07-16 10:29:42.364399
60	81	200	472	2.000	70000.00	2026-07-16 11:48:46.572172	2026-07-16 11:49:35.105156
61	83	200	472	1.000	70000.00	2026-07-16 11:51:21.090076	2026-07-16 11:51:21.090093
62	85	200	472	1.000	70000.00	2026-07-16 11:54:16.752108	2026-07-16 11:54:16.752114
\.


--
-- TOC entry 3443 (class 0 OID 68012)
-- Dependencies: 213
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.categories (id, code, name, parent_id, description, is_active, created_at) FROM stdin;
1	DIEN_TU	Điện tử	\N	\N	f	2026-03-17 06:49:16.405915
7	HANG_TD	Hàng tiêu dùng	\N	\N	f	2026-03-17 06:49:16.422475
2	LAPTOP	Laptop	1	\N	f	2026-03-17 06:49:16.409042
6	NGUYEN_LIEU	Nguyên vật liệu	\N	\N	f	2026-03-17 06:49:16.419293
5	O_TO	Ô tô - Xe máy	\N	\N	f	2026-03-17 06:49:16.416232
4	THUC_PHAM	Thực phẩm	\N	\N	f	2026-03-17 06:49:16.413186
3	VAN_PHONG	VPP	\N	None	t	2026-03-17 06:49:16.410985
9	KEPBUOM	Kẹp Bướm	\N	Kẹp Bướm Các Loại	t	2026-05-28 15:44:42.628587
11	EPNHIET	Ép Nhiệt	\N	Tấm nhựa ép các loại	t	2026-05-28 15:59:04.002715
12	BIALO	Bìa Lỗ	\N	Bìa Lỗ các loại	t	2026-05-28 16:09:50.19801
13	GN	Note	\N	Giấy Note Các loại	t	2026-06-15 11:41:42.185313
10	GIAYA3	GIẤY Smartist	\N	GIẤY Smartist	t	2026-05-28 15:52:37.581482
8	GIẤY A4	GIẤY Double A	\N		t	2026-04-23 04:35:34.239241
\.


--
-- TOC entry 3506 (class 0 OID 99943)
-- Dependencies: 276
-- Data for Name: customer_accounts; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.customer_accounts (id, customer_id, email, password_hash, name, phone, is_active, created_at, last_login, role) FROM stdin;
4	\N	tranvanb@mail.com	scrypt:32768:8:1$rbCIOVXTgpnW2Kse$a55a19349e2d10aa0b67d88264bb17e755c55c1e20a977bc0d3756089699bb8b2292af048c60a110b148cb35aa005a80f7c2128bcc7e2853a70e297116f62b91	TRẦN VĂN B		t	2026-06-12 17:02:21.847626	\N	web_customer
17	295	web1056@test.com	scrypt:32768:8:1$60TL1ShpkT0VmMqY$c2707c3998d8c6f2d85423b886dd304f5ca577cd7a681d3bcd06c244561c6f369ba7f32200c0861b6361fe88344f1fd2ad1f96eb1990fd2b8e2c0a293a5523fc	Updated Name	0987654321	t	2026-07-16 10:24:06.475836	\N	web_customer
12	290	web3865@test.com	scrypt:32768:8:1$l72xs8WVeMJE8RBF$e943a2938216a417df5e02fd3e7be74165db14734c0145a5d81f49db1bdaef1f36a2be1ab6d701c26a25e3447bad08aa4e71e28351c374efad92ff95cd66f2da	Updated Name	0987654321	t	2026-07-16 10:17:27.104404	\N	web_customer
13	291	web8886@test.com	scrypt:32768:8:1$9yXMIenHyVbyoKcX$2b40dce72ce52cd275688a3b8f7f292651b883b2dd48e9829d52de692452212bcc43efa5438134d2707418ed1365251c525d63b5a03296c94d31d7a28767027a	Updated Name	0987654321	t	2026-07-16 10:18:14.108845	\N	web_customer
5	\N	test3398@test.com	scrypt:32768:8:1$wTJHIYllZONoz0U3$76533a3d0a9555ec7578c4bf0fe0d759c895143963057e89aad7e3c44e8c772f2065c323c250cbd1be560b0c32f3144106d8434b011a78a3de14d60e3840ce9e	Test User		t	2026-07-16 07:07:17.23792	\N	web_customer
14	292	web9066@test.com	scrypt:32768:8:1$uyXtcfXzs9wP69m3$d01b7d0a2245062fb3b9c078fb35eb4d1fb3fb271522c5463a435129c642cfe31d1253f4b12ce6046549e9c29f0ea93e1520e0838ec110e2c5cfda12571b7fb0	Updated Name	0987654321	t	2026-07-16 10:19:22.782242	\N	web_customer
6	289	web8853@test.com	scrypt:32768:8:1$U4Kjl0JxOh0hsuRn$8b314a8328a1bcaaeb0ee56c28054fb8d65505c4cac74b4230dcd9054fbc5c35f3c39ba3af1324397af3271350c8fda45feea281115926e15424ba872e6477da	Updated Name	0987654321	t	2026-07-16 10:10:26.986457	\N	web_customer
7	\N	web9793@test.com	scrypt:32768:8:1$yFBqY5KKcStvEmNp$cca8bf01fa84ddc13b4e4dab4d7193d4c12dc8d016514a17a915e1e5cf88e83b6945220b6165a8b4d9b36ff7439a0cb769cab47157b11ec896aa90626894d3fb	Updated Name	0987654321	t	2026-07-16 10:12:23.13512	\N	web_customer
8	\N	web2933@test.com	scrypt:32768:8:1$pZPfs5CoegVDG1o5$49e16c8c4785dcd5bfc938870e2176a61a92050aeb45d58b96bb4379f9f91e810eddc831953d8b83871374b97ae28cd45bfd1bff207be08bc22523ecad88799a	Updated Name	0987654321	t	2026-07-16 10:13:22.324154	\N	web_customer
9	\N	web5769@test.com	scrypt:32768:8:1$GFV491eKPDc5b04x$fb2e98bc7eb89cc0760e833008270d828d287caf5ff10ff6720322a45cdc881ed562ece868ffdec60feca3ac36b74447526a60f097baa0a438e083c07838944e	Updated Name	0987654321	t	2026-07-16 10:14:26.723534	\N	web_customer
18	296	web7216@test.com	scrypt:32768:8:1$EB1vvBy3SDHuuuRW$54013f92455d564f6ded60443fc64ffc1120ccaa710d9b6c803806dd08169251b4ed46baec223fb1c202d2962a38fb93657d58a485df29e99f00a3824fab5715	Updated Name	0987654321	t	2026-07-16 10:26:19.559609	\N	web_customer
15	293	web2664@test.com	scrypt:32768:8:1$cxTmWcqRRyTSLPIm$d1880c16de6e21bcd9645f7c2185bd3848f869bccbe4bbc61fd73b8a38d088fa3c9303f4424e83726ff2eea62489ab6147a9d7587c8604d2af8a84a2ba380257	Updated Name	0987654321	t	2026-07-16 10:21:30.568374	\N	web_customer
10	\N	web5491@test.com	scrypt:32768:8:1$WCKiC5uBsa9SDTNc$0663cd9763acf7a60379354472e65c5721a46bf1a6695685095858b85ab340f529c0ee2d87885e90cf25fb6925cac2153f4299f034a66ed5e470ad0d4bcf0954	Updated Name	0987654321	t	2026-07-16 10:15:19.35054	\N	web_customer
11	\N	web4695@test.com	scrypt:32768:8:1$UKecqZ0WjbzAOZzO$9b7be9d496dcaff66eaeae6cdddd0e71a8e8c2b14e790131bc02f970f805a0ea2c5179504d7697853a9d63882f6057c63eb27b7ebd0928b06b676f2399d0b4ee	Updated Name	0987654321	t	2026-07-16 10:16:28.801742	\N	web_customer
16	294	web9729@test.com	scrypt:32768:8:1$DqTS4vvViBA40xNv$e3949744662c12048fd620127a4874d9473f81c93380f6c6d84ce61b4dbea0e05656512ab0a94cf95cd8e79bea0de99c8dc32b22c98a834dc545df699fe45ece	Updated Name	0987654321	t	2026-07-16 10:23:14.341445	\N	web_customer
3	299	nguyenvana@mail.com	scrypt:32768:8:1$WGFM8BwDk9p1bBBk$e67bcae9c5080a48d551a115397defdf8de30d9e551987e557bc8774a225ecbb73ca9d4d513525756e40e38db585b2ca5a09b601ae89ccf91c98758540cd4cbc	Nguyen Van A	0903123456	t	2026-06-08 12:15:35.284028	2026-07-16 11:54:12.572496	web_customer
19	297	web6789@test.com	scrypt:32768:8:1$2y2XQnHDMLYhCawy$8dfe63dc49e029dc9b64b0a8dd22f28dae4700633d8f78d332ba3fec4989b1206431697ff12036fa1c6e27285fc05bb17590e0e90d6817f7d285dfcfcb829165	Updated Name	0987654321	t	2026-07-16 10:27:41.520294	\N	web_customer
20	298	final1578@test.com	scrypt:32768:8:1$x9WdJ4HWtwmaRc8y$543ebb1a22128fe9d529d2dfc7735c6bd432641990941a1f4f66c330686f39b0362e398cd90b3d10ef02e7e76ef7d534105172942b12cf1e821968e0af00dfc1	Final Test	0912345678	t	2026-07-16 10:29:40.287009	\N	web_customer
\.


--
-- TOC entry 3492 (class 0 OID 99756)
-- Dependencies: 262
-- Data for Name: customer_sessions; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.customer_sessions (id, session_key, customer_id, name, email, phone, created_at, last_seen_at, expires_at) FROM stdin;
66	jwt:16	294	Updated Name	web9729@test.com	0987654321	2026-07-16 10:23:20.521858	2026-07-16 10:23:22.606361	\N
43	02b2f503a6564c15b03f266eab1b6289	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 16:14:00.665463	2026-06-12 23:14:04.475634	2026-07-12 23:14:00.663961
31	2a4c6439b2b747f097c7b7169309b9bf	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-08 14:50:06.39719	2026-06-08 15:09:46.920652	2026-07-08 14:50:06.383566
54	jwt:3	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-07-16 07:04:44.993355	2026-07-16 11:54:20.884127	\N
67	jwt:17	295	Updated Name	web1056@test.com	0987654321	2026-07-16 10:24:12.638267	2026-07-16 10:24:14.724484	\N
32	3f2298b8d77d404cbfb2435eb3b9c7f5	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-08 15:54:39.521429	2026-06-08 15:55:20.939661	2026-07-08 15:54:39.501781
33	db82e79cc4ac4bd698db75e73b98ef8f	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-09 09:31:29.042501	2026-06-09 09:31:29.061487	2026-07-09 09:31:29.030264
34	f633fa5d23db445b84c117962d7b0c42	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-09 09:39:10.527857	2026-06-09 09:39:10.528981	2026-07-09 09:39:10.526118
35	1529e11b227f400eaebef0702e5143dc	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-09 12:00:41.295534	2026-06-09 19:00:03.788911	2026-07-09 19:00:03.788911
36	7ec02e94e1e5428babe090f4ad2d3c01	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-09 14:55:14.98871	2026-06-09 19:00:03.788911	2026-07-09 19:00:03.788911
37	b6d1e36f7fd344c4af8868a595659cd4	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-11 01:51:13.566798	2026-06-11 08:49:19.212033	2026-07-11 08:49:19.212033
38	d425d6d9a91e4da5aaa80433c28cb668	\N	\N	\N	\N	2026-06-12 09:46:34.654882	2026-06-12 16:46:34.726273	2026-07-12 16:46:34.626839
44	460718fce9e9477cbd3f7fa539240ecc	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 16:16:48.617722	2026-06-12 23:16:54.059286	2026-07-12 23:16:48.61579
39	fd3e530320c3472aa174ac7b9f50bfc7	\N	\N	\N	\N	2026-06-12 10:56:43.588801	2026-06-12 17:56:57.741157	2026-07-12 17:56:43.586185
49	b8578a1b92e2474387c305907d575193	\N	TRẦN VĂN B	tranvanb@mail.com		2026-06-12 16:49:19.579203	2026-06-13 00:04:44.902695	2026-07-12 23:49:19.577566
40	4025e5b8d32b4569b382be699544468e	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 13:36:42.926129	2026-06-12 21:58:55.32249	2026-07-12 20:36:42.911333
45	1ed94fa5e5134310aeb69e8ed8dbd444	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 16:18:53.816846	2026-06-12 23:18:58.828612	2026-07-12 23:18:53.815414
55	64989de884804f34904c702390d72422	\N	\N	\N	\N	2026-07-16 07:06:51.163789	2026-07-16 07:06:51.164803	\N
201	57331b1f19b24b51b1563b7eeec344d7	\N	\N	\N	\N	2026-07-20 16:09:53.610323	2026-07-20 23:10:07.343124	2026-08-19 23:09:53.606473
69	jwt:18	296	Updated Name	web7216@test.com	0987654321	2026-07-16 10:26:25.741076	2026-07-16 10:26:27.830093	\N
50	6a324157091b4fbca568710f7920dbf4	\N	\N	\N	\N	2026-06-18 10:33:11.26039	2026-06-18 18:19:46.564499	2026-07-18 17:33:11.24757
46	97e3cba7aeb84ba281179a79bb821fe6	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 16:23:46.78572	2026-06-12 23:24:17.851978	2026-07-12 23:23:46.785321
41	e575efe2428b45e895c55ed19aa7d95f	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 15:41:50.927629	2026-06-12 23:06:41.964108	2026-07-12 22:41:50.915453
70	jwt:19	297	Updated Name	web6789@test.com	0987654321	2026-07-16 10:27:47.702585	2026-07-16 10:27:49.803791	\N
42	014380bb8743415bac2454f546ef26bd	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 16:07:37.530443	2026-06-12 23:07:42.594569	2026-07-12 23:07:37.528485
47	796b322f60ca4c76b61ec4ab36e279ba	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 16:29:56.542796	2026-06-12 23:30:22.642303	2026-07-12 23:29:56.541196
51	bc3fba64311246ae9d5e4ff768048fad	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-19 15:40:33.459229	2026-06-20 00:35:06.437084	2026-07-19 22:40:33.457661
48	d513900e321a44fd8094eaa3aa1fb7a2	\N	Nguyen Van A	nguyenvana@mail.com	0903123456	2026-06-12 16:38:22.318062	2026-06-12 23:38:45.250215	2026-07-12 23:38:22.31613
71	jwt:20	298	Final Test	final1578@test.com	0912345678	2026-07-16 10:29:42.350478	2026-07-16 10:29:44.434118	\N
63	jwt:13	291	Updated Name	web8886@test.com	0987654321	2026-07-16 10:18:20.27705	2026-07-16 10:18:22.359215	\N
64	jwt:14	292	Updated Name	web9066@test.com	0987654321	2026-07-16 10:19:28.971323	2026-07-16 10:19:31.058771	\N
65	jwt:15	293	Updated Name	web2664@test.com	0987654321	2026-07-16 10:21:36.736196	2026-07-16 10:21:38.823169	\N
80	3533f846244c41b0a27ee59b0f7bbe7b	\N	\N	\N	\N	2026-07-16 12:54:24.383253	2026-07-16 13:01:32.419096	\N
204	d5784eaf8d744ad192fcf3156e8adf65	\N	\N	\N	\N	2026-07-20 16:30:04.814841	2026-07-20 16:31:27.436223	\N
\.


--
-- TOC entry 3447 (class 0 OID 68040)
-- Dependencies: 217
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.customers (id, code, name, short_name, customer_type, address, phone, email, tax_code, contact_person, bank_account, bank_name, bank_branch, payment_terms, credit_limit, discount_rate, note, is_active, created_at) FROM stdin;
289	WEB-6	Updated Name	Updated Name	retail		0987654321	web8853@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:11:32.384199
290	WEB-12	Updated Name	Test Web Customer	retail		0987654321	web3865@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:17:27.115481
291	WEB-13	Updated Name	Test Web Customer	retail		0987654321	web8886@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:18:14.115556
292	WEB-14	Updated Name	Test Web Customer	retail		0987654321	web9066@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:19:22.786498
293	WEB-15	Updated Name	Test Web Customer	retail		0987654321	web2664@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:21:30.572361
294	WEB-16	Updated Name	Test Web Customer	retail		0987654321	web9729@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:23:14.345606
295	WEB-17	Updated Name	Test Web Customer	retail		0987654321	web1056@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:24:06.479782
296	WEB-18	Updated Name	Test Web Customer	retail		0987654321	web7216@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:26:19.568561
297	WEB-19	Updated Name	Test Web Customer	retail		0987654321	web6789@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:27:41.532396
298	WEB-20	Final Test	Final Test	retail		0912345678	final1578@test.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 10:29:40.293498
299	WEB-3	Nguyen Van A	Nguyen Van A	retail		0903123456	nguyenvana@mail.com	\N	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-07-16 11:49:39.301232
198	TDP	CTY: THÀNH ĐẠI PHÁT	\N	retail	98/16/3 ĐƯỜNG TÂY THẠNH ,PTÂY THẠNH , QTPHÚ	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.732211
199	TGIAO	CTY: THUẬN GIAO	\N	retail	355/26 NGUYỄN TRỌNG TUYỂN , P1 , Q TÂN BÌNH	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.733967
200	TGP	Thế Giới Phẳng	\N	retail	491 Tô Hiến Thành . Q10	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.735667
201	THA	VPP: TOÀN HÀ	\N	retail	56 LÊ LỢI	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.737383
202	THM	CTY: TRƯƠNG HOÀN MỸ	\N	retail	159/1/17 TRẦN VĂN ĐANG, P11 ,Q3	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.739438
203	THOA	VĂN PHÒNG PHẨM . THANH HOA	\N	retail	62 - ĐƯỜNG TRẦN CHÁNH CHIẾU , P14 ,Q5	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.741376
204	THTHUAN	CTY: TNHH TM DV QC XD TÂN HÙNG THUẬN	\N	retail	107/4A NGÔ ĐỨC KẾ , P, 12 Q BÌNH THẠNH	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.743827
205	THUY	CTY: TNHH TM & DV TĂNG HUY	\N	retail	99/24 B LÊ ĐỨC THỌ , P17 , Q GÒ VẤP , TP HCM	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.745651
206	TK	Nhà sách Nguyễn Văn Cừ ( tổng kho )	\N	retail	356 Lê Quang Sung ,Q6	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.747376
207	TKHANG	CTY: THẢO KHANG	\N	retail	30B TRẦN KHÁNH DƯ ,  PLEIKU, GIA LAI	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.749179
208	TLUAT	CTY CP VPP TRI LUAT	\N	retail	63C-C XA PHU HOA -P 5 -Q 11	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.7509
209	TMINH	CTY: THÔNG MINH	\N	retail	51 NGUYỄN ĐÌNH KIÊN , PTÂN TẠO A, QBÌNH TÂN	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.752575
210	TNHI	VPP: TRANG NHI	\N	retail	97 CƯ XÁ TRẦN QUANG DiỆU , P 14 , Q 3,	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.754241
211	toanp	VPP: TOÀN PHÁT	\N	retail	HỒ DỨC AN - GIA LAI	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.756866
212	TP	CTY ĐÔNG THỊNH PHÁT	\N	retail		\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.759018
213	TPDAT	CTY: THỊNH PHÁT ĐẠT	\N	retail	220/4A HOÀNG HOA THÁM , P5 , Q BÌNH THẠNH	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.761785
214	TPH	CTY TÂN PHƯƠNG HƯNG	\N	retail	số 22 đường XL 13. tổ 3, ấp hóa nhậ,.xã tân vĩnh hiệp, bình dương	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.763955
215	TPHAT	CTY: THUẬN PHÁT	\N	retail	170 BÀ HẠT , P9 , Q10	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.76584
216	TR	DĐỊA CHỈ : 232/15 TÔ HiỆU, P HIÊP TÂN, T PHÚ	\N	retail	232/15 , TÔ HiỆU , P HiỆP TÂN , TÂN PHÚ	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.767707
217	TSANH	VPP: TÂN SANH	\N	retail	HẢI THƯỢNG LÃN ÔNG	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.769583
218	TT	CTY : THU TRANG	\N	retail	45 ĐƯỜNG D1, F .TÂN HƯNG , Q7	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.771685
219	TTHANG	CTY THUẬN THẮNG	\N	retail	105 DƯỜNG Đ 2.P 25. Q BÌNH THẠNH	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.773553
220	tthao	THU THẢO	\N	retail		\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.77531
221	TTIEN	CTY: THUỶ TIÊN	\N	retail	98 PHAN VĂN TRỊ , P. 10 Q, GÒ VẤP	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.778678
222	TTPHAT	DNTN THÀNH THUẬN PHÁT	\N	retail	279 TRẦN NHÂN TÔN .P2 . Q 10	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.780735
223	TTRI	hưng gia long	\N	retail	9/1 A PHAN BỘI CHÂU , P2 , BÌNH THẠNH	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.782539
224	TUAND	CTY: CHÍ TuẤN ĐẠT	\N	retail	51 NGUYỄN ĐÌNH KIÊN , PTÂN TẠO A, QBÌNH TÂN	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.784285
225	TVAN	CTY: THANH VÂN	\N	retail	47/10 ĐƯỜNG NGUYỄN VĂN SĂNG , P.TSN, Q TPHÚ	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.786044
226	TVINH	CTY: TNHH TRẦN VINH	\N	retail	225 BA CU , P4 , TP VŨNG TÀU	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.788166
227	TVPHAT	CTY:  TNHH MTV - SX - TM TÂN VY PHÁT	\N	retail	1/6 KHU PHỐ 4 . PHAN VĂN HỚN .P TÂN THỚI NHẤT Q . 12	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.790005
228	TXUAN	CTY: CỔ PHẦN TRƯỜNG XUÂN	\N	retail	74 LÊ LỢI , PLEIKU	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.79172
229	VANHUNG	VĂN HÙNG - (NHA TRANG)	\N	retail		\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.793971
230	VBLONG	CTY : TNHH ViỆT BẢO LONG	\N	retail	280/40 BÙI HỮU NGHĨA , P 2 , Q BÌNH THẠNH	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.795834
231	VHOA	CY TNHH DỊCH VỤ IN VĂN HOÁ	\N	retail	85/6/2  cách mạng tháng tám , P. 12, Q. 10 , TP. HCM	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.797943
232	VHUNG	CTY: VĂN HÙNG	\N	retail	66 PHAN ĐÌNH PHÙNG , NHA TRANG	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.799758
234	VMHUNG	CTY: VĨNH MINH HƯNG	\N	retail	110/43/8 , BÀ HOM	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.805498
235	VNHAT	DNTN : ViỆT NHẬT	\N	retail	10/8KP ĐỒNG AN , P , BÌNH HÒA , TX .THUẬN AN , T BD	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.807266
236	VPP2-9	VPP 2-9	\N	retail	….TRAN HUNG DAO,LONG XUYEN	\r\n	\r\n	\r\n	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.809474
245	XVY	CTY: TNHH TM XUÂN VY	\N	retail	405/4 TRƯỜNG CHINH , P 14 , Q TÂN BÌNH	nan	nan	nan	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-04 08:29:46.828186
246	0304199387	Trường Đại Học Giao Thông Vận Tải TPHCM	\N	retail	Số 2, Đường Võ Oanh, Phường Thạnh Mỹ Tây, TP Hồ Chí Minh, Việt Nam.			0304199387	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.033283
247	0315039586	CÔNG TY CỔ PHẦN GIẤY AN PHÁT THỊNH	\N	retail	51/3 Đường số 18B, Khu phố 1, Phường Bình Hưng Hòa, Thành phố Hồ Chí Minh, Việt Nam.			0315039586	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.065675
248	1100616732-001	CHI NHÁNH 1 CÔNG TY TNHH  TIN HỌC ANH VIỆT	\N	retail	Số 12-14 Nguyễn Trung Trực, Phường Long An, Tây Ninh, Việt Nam.			1100616732-001	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.067752
249	0317553067	CÔNG TY TNHH MỘT THÀNH VIÊN PHOTOCOPY LỘC	\N	retail	280 Đường An Dương Vương, Phường Chợ Quán, TP Hồ Chí Minh, Việt Nam.			0317553067	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.070142
250	0313635576	CÔNG TY TNHH THIẾT KẾ IN ẤN KLCREATIVE	\N	retail	213 Nguyễn Văn Cừ, Phường Chợ Quán, TP Hồ Chí Minh, Việt Nam.			0313635576	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.072301
251	084185000034	HỘ KINH DOANH PHOTOCOPY HẠNH DUNG	\N	retail	38A Lý Chiêu Hoàng, Phường Bình Phú, Thành Phố Hồ Chí Minh, Việt Nam			084185000034	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.074789
252	030184013239	HỘ KINH DOANH NGUYỄN THỊ YẾN	\N	retail	199 Trương Công Định, Phường Vũng Tàu, TP Hồ Chí Minh, Việt Nam			030184013239	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.076985
253	8262168854-001	HỘ KINH DOANH PHOTO HOÀNG VINH	\N	retail	298 Bùi Thị Xuân, Phường Xuân Hương - Đà Lạt, Lâm Đồng, Việt Nam.			8262168854-001	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.079071
255	2001276163	CÔNG TY TNHH DỊCH VỤ LÂM HÀ	\N	retail	Số 59A, đường Hùng Vương, Khóm 20, Phường Tân Thành, Cà Mau, Việt Nam.			2001276163	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.083302
256	1101854761	VĂN PHÒNG CÔNG CHỨNG PHẠM THỊ HIÊN	\N	retail	Số 12-14 Trà Quý Bình, Phường 1(Hết hiệu lực), Tây Ninh, Việt Nam.			1101854761	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.085528
257	0314514172	CÔNG TY TNHH THƯƠNG MẠI - DỊCH VỤ IN ẤN BỐN PHƯƠNG	\N	retail	Số 107 Đường Phù Đổng Thiên Vương, Phường Chợ Lớn, TP Hồ Chí Minh, Việt Nam.			0314514172	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.087666
259	3801132839	CÔNG TY TNHH MỘT THÀNH VIÊN THƯƠNG MẠI DỊCH VỤ TIN HỌC ĐĂNG QUẢNG	\N	retail	265 Nguyễn Huệ, Khu phố Phú Bình, Phường Bình Long, Đồng Nai, Việt Nam.			3801132839	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.092685
260	0316371113	CÔNG TY TNHH SẢN XUẤT VÀ THƯƠNG MẠI GIẤY QUỐC TOÀN PHÁT	\N	retail	50/1/28/32 Nguyễn Quý Yêm, Khu phố 4, Phường An Lạc, Thành phố Hồ Chí Minh, Việt Nam.			0316371113	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.094758
261	084184013210	HỘ KINH DOANH PHONG THẢO	\N	retail	623 Đường Bình Thới, Phường Bình Thới, Thành Phố Hồ Chí Minh, Việt Nam			084184013210	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.096446
262	8842624116-001	HỘ KINH DOANH PHOTOCOPY HOÀNG AN	\N	retail	146 Trần Văn Kiểu, Phường Bình Phú, TP Hồ Chí Minh, Việt Nam.			8842624116-001	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.098088
263	3600135029	NGUYỄN QUANG	\N	retail	Ấp Phương Mai 1, Xã Phú Lâm, Tỉnh Đồng Nai, Việt Nam			3600135029	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.099815
264	1601333527	CÔNG TY TNHH DƯỢC PHẨM HỮU THÀNH	\N	retail	Số 86 đường Nguyễn Văn Cừ, Xã Phú Tân, Tỉnh An Giang, Việt Nam			1601333527	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.101849
265	0301814637	CÔNG TY TNHH TƯ VẤN XÂY DỰNG CAO CƯỜNG	\N	retail	35 Đường số 72, Phường Bình Phú, TP Hồ Chí Minh, Việt Nam.			0301814637	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.103655
267	0312659648	CÔNG TY TNHH TƯ VẤN XÂY DỰNG THUẬN BÌNH MINH	\N	retail	45 đường 17B, Phường An Lạc, TP Hồ Chí Minh, Việt Nam.			0312659648	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.106909
268	0318286826	CÔNG TY TNHH IN ẤN HOÀNG DŨNG	\N	retail	37 Thạch Lam, Phường Phú Thạnh, TP Hồ Chí Minh, Việt Nam.			0318286826	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.109954
269	0313334378	CÔNG TY TNHH THƯƠNG MẠI VPP SÀI GÒN	\N	retail	77/6 Khu phố 4, Đường Trần Xuân Soạn, Phường Tân Hưng, Quận 7, Thành phố Hồ Chí Minh, Việt Nam			0313334378	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.111897
270	0312437941	CÔNG TY TNHH MỘT THÀNH VIÊN ĐỨC HÂN PHÁT	\N	retail	9/7 Nguyễn Quý Yêm, Khu phố 4, Phường An Lạc, Thành phố Hồ Chí Minh, Việt Nam.			0312437941	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.113601
271	0313460301	CÔNG TY TNHH SẢN XUẤT AROMA	\N	retail	185 Âu Cơ, Phường Hòa Bình, TP Hồ Chí Minh, Việt Nam.			0313460301	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.115224
272	0309424068	CÔNG TY CỔ PHẦN  THI TRẦN	\N	retail	245/23 Bến Ba Đình, Phường Chánh Hưng, TP Hồ Chí Minh, Việt Nam.			0309424068	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.117136
273	030180011462	HỘ KINH DOANH TRẦN THỊ DUYÊN	\N	retail	Số 8 Đường 30/4, Phường Tam Thắng, Thành Phố Hồ Chí Minh, Việt Nam			030180011462	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.118835
274	0317243682	CÔNG TY TNHH THƯƠNG MẠI DỊCH VỤ KỸ THUẬT IN PHƯỚC LÊ	\N	retail	121 Nguyễn Chí Thanh, Phường An Đông, TP Hồ Chí Minh, Việt Nam.			0317243682	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.120578
275	0304856635	CÔNG TY CỔ PHẦN ĐÀO TẠO QUỐC TẾ MỸ ÚC	\N	retail	62 - 62A Minh Phụng, Phường Bình Tây, TP Hồ Chí Minh, Việt Nam.			0304856635	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.12224
276	0313880779	CÔNG TY TNHH LÂM SONG MINH	\N	retail	193/18 Nam Kỳ Khởi Nghĩa, Phường Xuân Hòa, TP Hồ Chí Minh, Việt Nam.			0313880779	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.123884
278	0304877917	CÔNG TY TNHH DỊCH VỤ THƯƠNG MẠI NGÔ MAI	\N	retail	477 Tô Hiến Thành, Phường Diên Hồng, TP Hồ Chí Minh, Việt Nam.			0304877917	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.127787
279	1101805387	CÔNG TY TNHH THIẾT BỊ TIN HỌC TIẾN PHÁT	\N	retail	Số 216/1/18 Khu phố 2, Xã Cần Giuộc, Tây Ninh, Việt Nam.			1101805387	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.129443
280	082082004065	ĐINH VIẾT TRUNG	\N	retail	nan			082082004065	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.131298
254	0312087856	CÔNG TY TNHH TMDV MÃ THƯỢNG		retail	Lầu 1, Số 72 Đường Nguyễn Xí, Phường Bình Thạnh, TP Hồ Chí Minh, Việt Nam.			0312087856	None	None	None	\N	30	0.00	0.00	None	t	2026-05-06 08:31:41.081201
266	0304923539	CÔNG TY TNHH TMDV PHOTO PHƯƠNG ĐÔNG		retail	91 Nguyễn Chí Thanh, Phường An Đông, TP Hồ Chí Minh, Việt Nam.			0304923539	None	None	None	\N	30	0.00	0.00	None	t	2026-05-06 08:31:41.105298
258	0303209924	CÔNG TY TNHH TMDV P.T PHÚC THỊNH		retail	292/33/5 Bình Lợi, Phường Bình Lợi Trung, TP Hồ Chí Minh, Việt Nam.			0303209924	None	None	None	\N	30	0.00	0.00	None	t	2026-05-06 08:31:41.089808
281	0316348481	CÔNG TY TNHH DỊCH VỤ TÂN THÁI HÒA	\N	retail	205 Điện Biên Phủ, Phường Gia Định, TP Hồ Chí Minh, Việt Nam.			0316348481	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.133018
282	0314634261	CÔNG TY TNHH SẢN XUẤT THƯƠNG MẠI BAO BÌ GIẤY MINH TIẾN	\N	retail	399/20 Bình Thành, Phường Bình Tân, TP Hồ Chí Minh, Việt Nam			0314634261	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.13511
283	0317827007	CÔNG TY TNHH THƯƠNG MẠI DỊCH VỤ PHOTOCOPY HƯNG PHÁT	\N	retail	90/15C Đường số 4, Phường Hiệp Bình, TP Hồ Chí Minh, Việt Nam.			0317827007	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.136746
286	0315899341	CÔNG TY TNHH THƯƠNG MẠI DỊCH VỤ BK VIỆT THÔNG	\N	retail	6 Đường 64, Phường Bình Trưng, Thành phố Hồ Chí Minh, Việt Nam.			0315899341	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.142188
287	0317587041	CÔNG TY TNHH IN CHÍNH ĐỨC	\N	retail	343E/16 Lạc Long Quân, Phường Hòa Bình, TP Hồ Chí Minh, Việt Nam.			0317587041	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.143866
288	0303158155-006	CÔNG TY IN VĂN HÓA SÀI GÒN	\N	retail	160 Dương Tử Giang, Phường Chợ Lớn, TP Hồ Chí Minh, Việt Nam.			0303158155-006	\N	\N	\N	\N	30	0.00	0.00	\N	t	2026-05-06 08:31:41.14521
277	0313684950	CÔNG TY TNHH MTV TMDV XNK THUẬN TUẤN		retail	41A Hoàng Ngân, Phường Phú Định, TP Hồ Chí Minh, Việt Nam.			0313684950	None	None	None	\N	30	0.00	0.00	None	t	2026-05-06 08:31:41.126128
285	0304491328	CÔNG TY TNHH TM VÀ XNK TRẦN NGUYỄN - TNECHO		retail	44 Đường số 8B, KDC Đại Phúc Green Villas Phạm Hùng, Xã Bình Hưng, TP Hồ Chí Minh, Việt Nam.			0304491328	None	None	None	\N	30	0.00	0.00	None	t	2026-05-06 08:31:41.140037
284	0313256828	CÔNG TY TNHH SX GIẤY VĂN PHÒNG PHẨM HOA SEN		retail	160/78 Phan Huy ích, Phường 12, Quận Gò Vấp, Thành phố Hồ Chí Minh, Việt Nam			0313256828	None	None	None	\N	30	0.00	0.00	None	t	2026-05-06 08:31:41.138353
\.


--
-- TOC entry 3465 (class 0 OID 68213)
-- Dependencies: 235
-- Data for Name: debt_payments; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.debt_payments (id, debt_id, date, amount, payment_method, reference, note, created_by, created_at) FROM stdin;
1	1	2026-06-13	5090000.00	cash			1	2026-06-13 07:10:06.181378
2	2	2026-06-14	3500000.00	cash			1	2026-06-13 17:03:16.975423
3	3	2026-06-14	27000000.00	cash			1	2026-06-13 17:46:33.064062
4	4	2026-06-14	1750000.00	cash			1	2026-06-13 17:48:37.542257
5	5	2026-06-26	2450000.00	cash			1	2026-06-26 15:29:06.360021
6	6	2026-07-02	2700000.00	cash			1	2026-07-02 11:10:20.366605
\.


--
-- TOC entry 3453 (class 0 OID 68084)
-- Dependencies: 223
-- Data for Name: debts; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.debts (id, partner_type, partner_id, reference_type, reference_id, reference_code, date, due_date, amount, paid_amount, balance, currency, status, note, created_at, updated_at) FROM stdin;
1	customer	275	stock_out	16	PX-260612-001	2026-06-12	2026-07-12	5090000.00	5090000.00	0.00	VND	paid	\N	2026-06-12 16:43:24.329813	2026-06-13 07:10:06.216425
2	customer	255	stock_out	18	PX-260614-001	2026-06-13	2026-07-13	3500000.00	3500000.00	0.00	VND	paid	\N	2026-06-13 17:01:05.846869	2026-06-13 17:03:16.98007
3	supplier	17	stock_in	1	PN-260614-001	2026-06-14	2026-07-14	27000000.00	27000000.00	0.00	VND	paid	\N	2026-06-13 17:45:58.133579	2026-06-13 17:46:33.071268
4	customer	272	stock_out	19	PX-260614-002	2026-06-14	2026-07-14	1750000.00	1750000.00	0.00	VND	paid	\N	2026-06-13 17:48:10.242269	2026-06-13 17:48:37.544951
5	customer	275	stock_out	20	PX-260616-001	2026-06-16	2026-07-16	2450000.00	2450000.00	0.00	VND	paid	\N	2026-06-16 04:10:52.151907	2026-06-26 15:29:06.459011
6	customer	255	stock_out	21	PX-260702-001	2026-07-02	2026-08-01	2700000.00	2700000.00	0.00	VND	paid	\N	2026-07-02 11:09:52.311159	2026-07-02 11:10:20.405976
\.


--
-- TOC entry 3515 (class 0 OID 111854)
-- Dependencies: 285
-- Data for Name: erp_users; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.erp_users (id, username, email, password_hash, full_name, role, is_active, last_login, created_at) FROM stdin;
\.


--
-- TOC entry 3473 (class 0 OID 68290)
-- Dependencies: 243
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.inventory (id, product_id, warehouse_id, quantity, avg_cost, last_updated) FROM stdin;
1	377	2	100000.000	0.00	2026-05-27 10:56:29.832067
2	378	2	100000.000	0.00	2026-05-27 10:56:29.846683
3	379	2	100000.000	0.00	2026-05-27 10:56:29.856024
4	380	2	100000.000	0.00	2026-05-27 10:56:29.865503
5	381	2	100000.000	0.00	2026-05-27 10:56:29.873214
7	389	2	100000.000	0.00	2026-05-27 10:56:29.888984
8	390	2	100000.000	0.00	2026-05-27 10:56:29.895725
9	382	2	100000.000	0.00	2026-05-27 10:56:29.903708
10	383	2	100000.000	0.00	2026-05-27 10:56:29.911883
11	384	2	100000.000	0.00	2026-05-27 10:56:29.919361
12	385	2	100000.000	0.00	2026-05-27 10:56:29.929554
13	386	2	100000.000	0.00	2026-05-27 10:56:29.940037
14	387	2	100000.000	0.00	2026-05-27 10:56:29.947814
15	391	2	100000.000	0.00	2026-05-27 10:56:29.956156
16	392	2	100000.000	0.00	2026-05-27 10:56:29.963147
17	393	2	100000.000	0.00	2026-05-27 10:56:29.970385
18	394	2	100000.000	0.00	2026-05-27 10:56:29.975273
19	395	2	100000.000	0.00	2026-05-27 10:56:29.979337
20	396	2	100000.000	0.00	2026-05-27 10:56:29.983615
21	397	2	100000.000	0.00	2026-05-27 10:56:29.987114
22	398	2	100000.000	0.00	2026-05-27 10:56:29.99002
23	399	2	100000.000	0.00	2026-05-27 10:56:29.993905
24	400	2	100000.000	0.00	2026-05-27 10:56:29.996952
25	401	2	100000.000	0.00	2026-05-27 10:56:30.001238
26	402	2	100000.000	0.00	2026-05-27 10:56:30.004457
27	403	2	100000.000	0.00	2026-05-27 10:56:30.007464
28	404	2	100000.000	0.00	2026-05-27 10:56:30.011015
29	405	2	100000.000	0.00	2026-05-27 10:56:30.014124
30	406	2	100000.000	0.00	2026-05-27 10:56:30.018849
31	407	2	100000.000	0.00	2026-05-27 10:56:30.022015
32	414	2	100000.000	0.00	2026-05-27 10:56:30.02573
33	408	2	100000.000	0.00	2026-05-27 10:56:30.028712
34	409	2	100000.000	0.00	2026-05-27 10:56:30.032828
35	410	2	100000.000	0.00	2026-05-27 10:56:30.03677
36	411	2	100000.000	0.00	2026-05-27 10:56:30.039995
37	412	2	100000.000	0.00	2026-05-27 10:56:30.043128
38	413	2	100000.000	0.00	2026-05-27 10:56:30.046246
39	415	2	100000.000	0.00	2026-05-27 10:56:30.0502
40	416	2	100000.000	0.00	2026-05-27 10:56:30.053421
41	417	2	100000.000	0.00	2026-05-27 10:56:30.057325
42	418	2	100000.000	0.00	2026-05-27 10:56:30.060271
43	419	2	100000.000	0.00	2026-05-27 10:56:30.063464
44	420	2	100000.000	0.00	2026-05-27 10:56:30.067181
45	421	2	100000.000	0.00	2026-05-27 10:56:30.070721
46	423	2	100000.000	0.00	2026-05-27 10:56:30.074035
47	424	2	100000.000	0.00	2026-05-27 10:56:30.077167
48	422	2	100000.000	0.00	2026-05-27 10:56:30.080444
49	425	2	100000.000	0.00	2026-05-27 10:56:30.084897
50	426	2	100000.000	0.00	2026-05-27 10:56:30.089279
51	427	2	100000.000	0.00	2026-05-27 10:56:30.092935
52	428	2	100000.000	0.00	2026-05-27 10:56:30.09615
53	429	2	100000.000	0.00	2026-05-27 10:56:30.100492
54	430	2	100000.000	0.00	2026-05-27 10:56:30.104105
55	431	2	100000.000	0.00	2026-05-27 10:56:30.107264
56	432	2	100000.000	0.00	2026-05-27 10:56:30.110281
57	433	2	100000.000	0.00	2026-05-27 10:56:30.113433
58	434	2	100000.000	0.00	2026-05-27 10:56:30.117332
65	441	2	100000.000	0.00	2026-05-27 10:56:30.139925
66	442	2	100000.000	0.00	2026-05-27 10:56:30.143178
67	443	2	100000.000	0.00	2026-05-27 10:56:30.146278
68	444	2	100000.000	0.00	2026-05-27 10:56:30.150998
59	435	2	99862.000	0.00	2026-06-12 16:43:24.300172
60	436	2	99856.000	0.00	2026-06-12 16:43:24.306844
61	437	2	99900.000	0.00	2026-06-12 16:43:24.311154
62	438	2	99900.000	0.00	2026-06-12 16:43:24.314915
63	439	2	99900.000	0.00	2026-06-12 16:43:24.318995
64	440	2	99900.000	0.00	2026-06-12 16:43:24.324785
103	479	2	99900.000	0.00	2026-07-02 11:09:52.209515
6	388	2	100743.000	247.82	2026-07-16 10:32:19.820668
69	445	2	100000.000	0.00	2026-05-27 10:56:30.154622
70	446	2	100000.000	0.00	2026-05-27 10:56:30.157783
71	447	2	100000.000	0.00	2026-05-27 10:56:30.160773
72	448	2	100000.000	0.00	2026-05-27 10:56:30.164613
73	450	2	100000.000	0.00	2026-05-27 10:56:30.169169
74	449	2	100000.000	0.00	2026-05-27 10:56:30.172611
75	451	2	100000.000	0.00	2026-05-27 10:56:30.175736
76	452	2	100000.000	0.00	2026-05-27 10:56:30.179147
77	453	2	100000.000	0.00	2026-05-27 10:56:30.182888
78	454	2	100000.000	0.00	2026-05-27 10:56:30.186175
79	455	2	100000.000	0.00	2026-05-27 10:56:30.189153
80	456	2	100000.000	0.00	2026-05-27 10:56:30.192378
81	457	2	100000.000	0.00	2026-05-27 10:56:30.19618
82	458	2	100000.000	0.00	2026-05-27 10:56:30.199975
83	459	2	100000.000	0.00	2026-05-27 10:56:30.203227
84	460	2	100000.000	0.00	2026-05-27 10:56:30.206386
85	461	2	100000.000	0.00	2026-05-27 10:56:30.209425
86	462	2	100000.000	0.00	2026-05-27 10:56:30.212766
87	463	2	100000.000	0.00	2026-05-27 10:56:30.216758
88	464	2	100000.000	0.00	2026-05-27 10:56:30.22019
89	465	2	100000.000	0.00	2026-05-27 10:56:30.223455
90	466	2	100000.000	0.00	2026-05-27 10:56:30.226891
91	467	2	100000.000	0.00	2026-05-27 10:56:30.229983
92	468	2	100000.000	0.00	2026-05-27 10:56:30.234686
93	469	2	100000.000	0.00	2026-05-27 10:56:30.237917
94	470	2	100000.000	0.00	2026-05-27 10:56:30.241008
95	471	2	100000.000	0.00	2026-05-27 10:56:30.244939
97	473	2	100000.000	0.00	2026-05-27 10:56:30.252044
98	474	2	100000.000	0.00	2026-05-27 10:56:30.255149
99	475	2	100000.000	0.00	2026-05-27 10:56:30.258485
100	476	2	100000.000	0.00	2026-05-27 10:56:30.261668
101	477	2	100000.000	0.00	2026-05-27 10:56:30.265169
102	478	2	100000.000	0.00	2026-05-27 10:56:30.26841
96	472	2	99980.000	0.00	2026-06-12 16:39:38.586174
\.


--
-- TOC entry 3475 (class 0 OID 68310)
-- Dependencies: 245
-- Data for Name: inventory_history; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.inventory_history (id, product_id, warehouse_id, transaction_type, reference_code, quantity_change, quantity_before, quantity_after, unit_cost, note, created_at, created_by) FROM stdin;
1	377	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.839474	\N
2	378	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.850539	\N
3	379	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.860389	\N
4	380	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.868117	\N
5	381	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.87553	\N
6	388	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.883083	\N
7	389	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.89115	\N
8	390	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.898632	\N
9	382	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.906225	\N
10	383	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.914091	\N
11	384	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.923954	\N
12	385	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.933304	\N
13	386	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.942844	\N
14	387	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.951252	\N
15	391	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.958306	\N
16	392	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.965606	\N
17	393	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.972567	\N
18	394	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.976796	\N
19	395	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.980375	\N
20	396	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.984949	\N
21	397	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.988107	\N
22	398	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.991248	\N
23	399	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.994963	\N
24	400	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:29.99793	\N
25	401	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.002458	\N
26	402	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.005487	\N
27	403	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.00887	\N
28	404	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.012169	\N
29	405	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.015632	\N
30	406	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.019871	\N
31	407	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.023298	\N
32	414	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.02673	\N
33	408	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.029712	\N
34	409	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.034608	\N
35	410	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.037772	\N
36	411	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.041109	\N
37	412	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.044117	\N
38	413	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.04732	\N
39	415	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.051352	\N
40	416	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.055188	\N
41	417	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.058324	\N
42	418	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.061378	\N
43	419	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.064459	\N
44	420	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.068202	\N
45	421	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.071966	\N
46	423	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.075075	\N
47	424	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.078242	\N
48	422	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.081713	\N
49	425	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.086198	\N
50	426	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.090558	\N
51	427	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.094048	\N
52	428	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.097197	\N
53	429	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.102007	\N
54	430	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.105199	\N
55	431	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.10826	\N
56	432	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.111299	\N
57	433	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.114411	\N
58	434	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.118371	\N
59	435	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.121456	\N
60	436	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.124588	\N
61	437	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.127595	\N
62	438	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.130564	\N
63	439	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.134766	\N
64	440	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.137929	\N
65	441	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.14101	\N
66	442	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.144191	\N
67	443	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.147636	\N
68	444	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.152219	\N
69	445	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.155754	\N
70	446	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.158765	\N
71	447	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.16189	\N
72	448	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.16668	\N
73	450	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.170207	\N
74	449	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.173666	\N
75	451	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.176747	\N
76	452	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.180242	\N
77	453	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.183969	\N
78	454	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.187172	\N
79	455	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.190126	\N
80	456	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.193436	\N
81	457	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.197311	\N
82	458	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.201	\N
83	459	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.204266	\N
84	460	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.207406	\N
85	461	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.210591	\N
86	462	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.213774	\N
87	463	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.218043	\N
88	464	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.221218	\N
89	465	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.22446	\N
90	466	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.22794	\N
91	467	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.231036	\N
92	468	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.23583	\N
93	469	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.238917	\N
94	470	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.242507	\N
95	471	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.246009	\N
96	472	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.24971	\N
97	473	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.253108	\N
98	474	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.256192	\N
99	475	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.259536	\N
100	476	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.262773	\N
101	477	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.266334	\N
102	478	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-27 10:56:30.26919	\N
103	479	2	opening	OPEN-2026-05-01	100000.000	0.000	100000.000	0.00	Tồn đầu kỳ 2026-05-01	2026-05-28 13:49:57.33613	\N
104	435	2	stock_out	PX-260605-001	-10.000	100000.000	99990.000	0.00	Đơn online WEB-260604-0001	2026-06-05 13:05:05.557874	1
105	436	2	stock_out	PX-260605-002	-20.000	100000.000	99980.000	0.00	Đơn online WEB-260605-0001	2026-06-05 13:37:56.358222	1
106	435	2	stock_out	PX-260605-003	-1.000	99990.000	99989.000	0.00	Đơn online WEB-20260604-0001	2026-06-05 13:40:43.003353	1
107	436	2	stock_out	PX-260605-004	-14.000	99980.000	99966.000	0.00	Đơn online WEB-260605-0005	2026-06-05 15:42:30.295068	1
108	435	2	stock_out	PX-260605-005	-7.000	99989.000	99982.000	0.00	Đơn online WEB-260605-0004	2026-06-05 15:43:33.245583	1
109	435	2	stock_out	PX-260605-006	-9.000	99982.000	99973.000	0.00	Đơn online WEB-260605-0003	2026-06-05 15:43:36.480462	1
110	435	2	stock_out	PX-260605-007	-10.000	99973.000	99963.000	0.00	Đơn online WEB-260605-0002	2026-06-05 15:43:42.463291	1
111	435	2	stock_out	PX-260608-001	-1.000	99963.000	99962.000	0.00	Đơn online WEB-260608-0001	2026-06-08 15:13:35.386631	1
112	436	2	stock_out	PX-260608-001	-10.000	99966.000	99956.000	0.00	Đơn online WEB-260608-0001	2026-06-08 15:56:42.629423	1
113	472	2	stock_out	PX-260612-001	-10.000	100000.000	99990.000	0.00	Đơn online WEB-260612-0001	2026-06-12 15:50:55.831157	1
114	472	2	stock_out	PX-WEB-260612-0001	-10.000	99990.000	99980.000	0.00	\N	2026-06-12 16:39:38.595503	1
115	435	2	stock_out	PX-260612-001	-100.000	99962.000	99862.000	0.00	\N	2026-06-12 16:43:24.301495	1
116	436	2	stock_out	PX-260612-001	-100.000	99956.000	99856.000	0.00	\N	2026-06-12 16:43:24.307975	1
117	437	2	stock_out	PX-260612-001	-100.000	100000.000	99900.000	0.00	\N	2026-06-12 16:43:24.312253	1
118	438	2	stock_out	PX-260612-001	-100.000	100000.000	99900.000	0.00	\N	2026-06-12 16:43:24.31591	1
119	439	2	stock_out	PX-260612-001	-100.000	100000.000	99900.000	0.00	\N	2026-06-12 16:43:24.321107	1
120	440	2	stock_out	PX-260612-001	-100.000	100000.000	99900.000	0.00	\N	2026-06-12 16:43:24.325996	1
121	388	2	stock_out	PX-WEB-260613-0001	-20.000	100000.000	99980.000	0.00	\N	2026-06-13 06:08:28.448789	1
122	388	2	stock_out	PX-260614-001	-100.000	99980.000	99880.000	0.00	\N	2026-06-13 17:01:05.774908	1
123	388	2	stock_in	PN-260614-001	1000.000	99880.000	100880.000	25000.00	\N	2026-06-13 17:45:58.099163	1
124	388	2	stock_out	PX-260614-002	-50.000	100880.000	100830.000	247.82	\N	2026-06-13 17:48:10.232131	1
125	388	2	stock_out	PX-260616-001	-70.000	100830.000	100760.000	247.82	\N	2026-06-16 04:10:52.098613	1
126	479	2	stock_out	PX-260702-001	-100.000	100000.000	99900.000	0.00	\N	2026-07-02 11:09:52.213484	1
127	388	2	stock_out	PX-260716-001	-5.000	100760.000	100755.000	247.82	Đơn online WEB-260716-0004	2026-07-16 10:05:26.680181	1
128	388	2	stock_out	PX-260716-002	-1.000	100755.000	100754.000	247.82	Đơn online WEB-260716-0003	2026-07-16 10:05:35.24883	1
129	388	2	stock_out	PX-260716-003	-5.000	100754.000	100749.000	247.82	Đơn online WEB-260716-0002	2026-07-16 10:05:38.571203	1
130	388	2	stock_out	PX-260716-004	-5.000	100749.000	100744.000	247.82	Đơn online WEB-260716-0001	2026-07-16 10:05:42.413613	1
131	388	2	stock_out	PX-260716-005	-1.000	100744.000	100743.000	247.82	Đơn online WEB-260716-0012	2026-07-16 10:32:19.823505	1
\.


--
-- TOC entry 3463 (class 0 OID 68195)
-- Dependencies: 233
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.journal_entries (id, code, date, description, reference_type, reference_id, reference_code, total_debit, total_credit, status, note, created_by, created_at) FROM stdin;
1	JE-PX-WEB-260612-0001	2026-06-12	Hạch toán phiếu xuất PX-WEB-260612-0001	stock_out	15	PX-WEB-260612-0001	700000.00	700000.00	posted	\N	\N	2026-06-12 16:39:38.686999
2	JE-PX-260612-001	2026-06-12	Hạch toán phiếu xuất PX-260612-001	stock_out	16	PX-260612-001	5090000.00	5090000.00	posted	\N	\N	2026-06-12 16:43:24.408571
3	JE-PX-WEB-260613-0001	2026-06-13	Hạch toán phiếu xuất PX-WEB-260613-0001	stock_out	17	PX-WEB-260613-0001	700000.00	700000.00	posted	\N	\N	2026-06-13 06:08:28.553526
4	JE-DP-1	2026-06-13	Thu công nợ PX-260612-001	debt_payment	1	PX-260612-001	5090000.00	5090000.00	posted	\N	\N	2026-06-13 07:10:06.239252
5	JE-PX-260614-001	2026-06-13	Hạch toán phiếu xuất PX-260614-001	stock_out	18	PX-260614-001	3500000.00	3500000.00	posted	\N	\N	2026-06-13 17:01:05.937766
6	JE-DP-2	2026-06-14	Thu công nợ PX-260614-001	debt_payment	2	PX-260614-001	3500000.00	3500000.00	posted	\N	\N	2026-06-13 17:03:16.999389
7	JE-PN-260614-001	2026-06-14	Hạch toán phiếu nhập PN-260614-001	stock_in	1	PN-260614-001	27000000.00	27000000.00	posted	\N	\N	2026-06-13 17:45:58.194845
8	JE-DP-3	2026-06-14	Thanh toán công nợ PN-260614-001	debt_payment	3	PN-260614-001	27000000.00	27000000.00	posted	\N	\N	2026-06-13 17:46:33.083834
9	JE-PX-260614-002	2026-06-14	Hạch toán phiếu xuất PX-260614-002	stock_out	19	PX-260614-002	1762391.00	1762391.00	posted	\N	\N	2026-06-13 17:48:10.259848
10	JE-DP-4	2026-06-14	Thu công nợ PX-260614-002	debt_payment	4	PX-260614-002	1750000.00	1750000.00	posted	\N	\N	2026-06-13 17:48:37.557887
11	JE-PX-260616-001	2026-06-16	Hạch toán phiếu xuất PX-260616-001	stock_out	20	PX-260616-001	2467347.40	2467347.40	posted	\N	\N	2026-06-16 04:10:52.240168
12	JE-DP-5	2026-06-26	Thu công nợ PX-260616-001	debt_payment	5	PX-260616-001	2450000.00	2450000.00	posted	\N	\N	2026-06-26 15:29:06.535338
13	JE-PX-260702-001	2026-07-02	Hạch toán phiếu xuất PX-260702-001	stock_out	21	PX-260702-001	2700000.00	2700000.00	posted	\N	\N	2026-07-02 11:09:52.452258
14	JE-DP-6	2026-07-02	Thu công nợ PX-260702-001	debt_payment	6	PX-260702-001	2700000.00	2700000.00	posted	\N	\N	2026-07-02 11:10:20.427431
\.


--
-- TOC entry 3477 (class 0 OID 68333)
-- Dependencies: 247
-- Data for Name: journal_lines; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.journal_lines (id, entry_id, account_id, description, debit, credit, partner_type, partner_id, order_no) FROM stdin;
1	1	11	Hạch toán phiếu xuất PX-WEB-260612-0001	700000.00	0.00	\N	\N	0
2	1	76	Hạch toán phiếu xuất PX-WEB-260612-0001	0.00	700000.00	\N	\N	0
3	2	11	Hạch toán phiếu xuất PX-260612-001	5090000.00	0.00	\N	\N	0
4	2	76	Hạch toán phiếu xuất PX-260612-001	0.00	5090000.00	\N	\N	0
5	3	11	Hạch toán phiếu xuất PX-WEB-260613-0001	700000.00	0.00	\N	\N	0
6	3	76	Hạch toán phiếu xuất PX-WEB-260613-0001	0.00	700000.00	\N	\N	0
7	4	3	Thu công nợ PX-260612-001	5090000.00	0.00	\N	\N	0
8	4	11	Thu công nợ PX-260612-001	0.00	5090000.00	\N	\N	0
9	5	11	Hạch toán phiếu xuất PX-260614-001	3500000.00	0.00	\N	\N	0
10	5	76	Hạch toán phiếu xuất PX-260614-001	0.00	3500000.00	\N	\N	0
11	6	3	Thu công nợ PX-260614-001	3500000.00	0.00	\N	\N	0
12	6	11	Thu công nợ PX-260614-001	0.00	3500000.00	\N	\N	0
13	7	28	Hạch toán phiếu nhập PN-260614-001	25000000.00	0.00	\N	\N	0
14	7	15	Hạch toán phiếu nhập PN-260614-001	2000000.00	0.00	\N	\N	0
15	7	46	Hạch toán phiếu nhập PN-260614-001	0.00	27000000.00	\N	\N	0
16	8	46	Thanh toán công nợ PN-260614-001	27000000.00	0.00	\N	\N	0
17	8	3	Thanh toán công nợ PN-260614-001	0.00	27000000.00	\N	\N	0
18	9	11	Hạch toán phiếu xuất PX-260614-002	1750000.00	0.00	\N	\N	0
19	9	76	Hạch toán phiếu xuất PX-260614-002	0.00	1750000.00	\N	\N	0
20	9	93	Hạch toán phiếu xuất PX-260614-002	12391.00	0.00	\N	\N	0
21	9	28	Hạch toán phiếu xuất PX-260614-002	0.00	12391.00	\N	\N	0
22	10	3	Thu công nợ PX-260614-002	1750000.00	0.00	\N	\N	0
23	10	11	Thu công nợ PX-260614-002	0.00	1750000.00	\N	\N	0
24	11	11	Hạch toán phiếu xuất PX-260616-001	2450000.00	0.00	\N	\N	0
25	11	76	Hạch toán phiếu xuất PX-260616-001	0.00	2450000.00	\N	\N	0
26	11	93	Hạch toán phiếu xuất PX-260616-001	17347.40	0.00	\N	\N	0
27	11	28	Hạch toán phiếu xuất PX-260616-001	0.00	17347.40	\N	\N	0
28	12	3	Thu công nợ PX-260616-001	2450000.00	0.00	\N	\N	0
29	12	11	Thu công nợ PX-260616-001	0.00	2450000.00	\N	\N	0
30	13	11	Hạch toán phiếu xuất PX-260702-001	2700000.00	0.00	\N	\N	0
31	13	76	Hạch toán phiếu xuất PX-260702-001	0.00	2700000.00	\N	\N	0
32	14	3	Thu công nợ PX-260702-001	2700000.00	0.00	\N	\N	0
33	14	11	Thu công nợ PX-260702-001	0.00	2700000.00	\N	\N	0
\.


--
-- TOC entry 3478 (class 0 OID 68372)
-- Dependencies: 248
-- Data for Name: menu_roles; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.menu_roles (menu_id, role) FROM stdin;
13	admin
1	admin
1	user
1	accountant
1	warehouse
2	admin
2	user
2	accountant
2	warehouse
3	admin
3	user
3	accountant
3	warehouse
4	admin
4	user
4	accountant
4	warehouse
5	admin
5	user
5	accountant
5	warehouse
6	admin
6	user
6	accountant
6	warehouse
7	admin
7	user
7	accountant
7	warehouse
8	admin
8	user
8	accountant
8	warehouse
9	admin
9	user
9	accountant
9	warehouse
10	admin
10	user
10	accountant
10	warehouse
11	admin
11	user
11	accountant
11	warehouse
14	admin
14	user
14	accountant
14	warehouse
15	admin
15	user
15	accountant
15	warehouse
16	admin
16	user
16	accountant
16	warehouse
17	admin
17	user
17	accountant
17	warehouse
18	admin
18	user
18	accountant
18	warehouse
19	admin
19	user
19	accountant
19	warehouse
20	admin
20	user
20	accountant
20	warehouse
21	admin
21	user
21	accountant
21	warehouse
23	admin
23	user
23	accountant
23	warehouse
24	admin
24	user
24	accountant
24	warehouse
25	admin
25	user
25	accountant
25	warehouse
26	admin
26	user
26	accountant
26	warehouse
27	admin
27	user
27	accountant
27	warehouse
28	admin
28	user
28	accountant
28	warehouse
29	admin
29	user
29	accountant
29	warehouse
30	admin
30	user
30	accountant
30	warehouse
31	admin
31	user
31	accountant
31	warehouse
32	admin
32	user
32	accountant
32	warehouse
33	admin
33	user
33	accountant
33	warehouse
34	admin
34	user
34	accountant
34	warehouse
35	admin
35	user
35	accountant
35	warehouse
37	admin
37	accountant
37	warehouse
40	admin
40	accountant
41	accountant
41	admin
39	accountant
39	admin
42	accountant
42	admin
43	accountant
43	admin
22	admin
12	admin
44	admin
44	accountant
44	warehouse
46	admin
46	accountant
46	warehouse
47	admin
47	accountant
47	warehouse
45	admin
45	accountant
45	warehouse
\.


--
-- TOC entry 3433 (class 0 OID 67943)
-- Dependencies: 203
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.menus (id, code, name, parent_id, url, icon, order_no, module, roles, is_active, created_at) FROM stdin;
14	DEBT	Công nợ phải thu	13	/debt/?partner_type=customer	fas fa-hand-holding-usd	51	accounting		t	2026-03-17 06:49:16.289362
15	DEBT_PAY	Công nợ phải trả	13	/debt/?partner_type=supplier	fas fa-file-invoice	52	accounting		t	2026-03-17 06:49:16.291583
16	DEBT_SUMMARY	Tổng hợp công nợ	13	/debt/summary	fas fa-table	53	accounting		t	2026-03-17 06:49:16.296135
17	VAT_OUT	VAT đầu ra	13	/vat/?vat_type=output	fas fa-percent	54	accounting		t	2026-03-17 06:49:16.299398
18	VAT_IN	VAT đầu vào	13	/vat/?vat_type=input	fas fa-receipt	55	accounting		t	2026-03-17 06:49:16.301975
19	JOURNAL	Nhật ký kế toán	13	/accounting/	fas fa-book	56	accounting		t	2026-03-17 06:49:16.304282
20	TRIAL_BAL	Cân đối số PS	13	/accounting/trial-balance	fas fa-balance-scale	57	accounting		t	2026-03-17 06:49:16.307456
21	ACCOUNTS	Hệ thống TK	13	/accounting/accounts	fas fa-sitemap	58	accounting		t	2026-03-17 06:49:16.310298
23	SETTINGS_SYS	Cấu hình hệ thống	22	/settings/	fas fa-sliders-h	91	settings		t	2026-03-17 06:49:16.315956
24	SETTINGS_USERS	Quản lý users	22	/settings/users	fas fa-users-cog	92	settings		t	2026-03-17 06:49:16.31756
25	SETTINGS_MENU	Cấu hình menu	22	/settings/menus	fas fa-bars	93	settings		t	2026-03-17 06:49:16.319061
26	SETTINGS_NOTIF	Mẫu thông báo	22	/settings/notifications	fas fa-bell	94	settings		t	2026-03-17 06:49:16.320706
33	RPT_REALTIME	Tồn kho realtime	31	/reports/realtime-inventory	fas fa-satellite-dish	62	reports		t	2026-03-17 06:49:16.333799
34	RPT_CUSTOMER	DT theo khách hàng	31	/reports/customer-revenue	fas fa-chart-line	63	reports		t	2026-03-17 06:49:16.335155
35	RPT_SUPPLIER	Nhập theo NCC	31	/reports/supplier-purchase	fas fa-truck	64	reports		t	2026-03-17 06:49:16.336497
1	DASHBOARD	Tổng quan	\N	/dashboard	fas fa-tachometer-alt	1	dashboard		t	2026-03-17 06:49:16.240265
46	ECOMMERCE_LISTINGS	Sản phẩm web	45	/ecommerce/listings	fas fa-tags	1	ecommerce		t	2026-05-31 15:20:27.780827
29	CATEGORIES	Nhóm hàng hóa	2	/categories/	fas fa-tags	96	settings		t	2026-03-17 06:49:16.326878
28	UNITS	Đơn vị tính	2	/units/	fas fa-ruler	95	settings		t	2026-03-17 06:49:16.325457
47	ECOMMERCE_ORDERS	Đơn online	45	/ecommerce/orders	fas fa-receipt	2	ecommerce		t	2026-05-31 15:20:27.831294
37	SETTINGS_UNIT_CONVERSIONS	Quy đổi đơn vị	2	/settings/unit-conversions	fas fa-ruler-combined	97	settings		t	2026-03-25 14:08:31.097347
36	SETTINGS_DB	Backup / Restore DB	22	/settings/db/tools	fas fa-database	98	settings	\N	t	2026-03-22 06:49:16.336
4	WAREHOUSES	Danh mục kho	2	/warehouses/	fas fa-building	22	inventory		t	2026-03-17 06:49:16.255227
5	INVENTORY	Tồn kho (real-time)	2	/inventory/	fas fa-boxes	23	inventory		t	2026-03-17 06:49:16.257884
6	INVENTORY_HIST	Lịch sử biến động	2	/inventory/history	fas fa-history	24	inventory		t	2026-03-17 06:49:16.260533
42	ACCOUNTING_TT99_GENERAL_LEDGER	Sổ cái (TK 156)	13	/accounting/general-ledger/156	fas fa-book	68	accounting		t	2026-04-09 07:29:19.963271
13	ACCOUNTING	Kế toán	\N	\N	fas fa-calculator	5	accounting		t	2026-03-17 06:49:16.286579
7	PURCHASE	Mua hàng	\N	\N	fas fa-shopping-cart	3	\N		t	2026-03-17 06:49:16.265179
8	SUPPLIERS	Nhà cung cấp	7	/suppliers/	fas fa-truck	31	suppliers		t	2026-03-17 06:49:16.268285
30	COMPANY_INFO	Thông tin công ty	22	/company/	fas fa-building	90	settings		t	2026-03-17 06:49:16.328407
31	REPORTS	Báo cáo	\N	\N	fas fa-chart-bar	6	reports		t	2026-03-17 06:49:16.330447
32	RPT_MOVEMENT	Sổ nhập xuất tồn	31	/reports/stock-movement	fas fa-exchange-alt	61	reports		t	2026-03-17 06:49:16.33227
38	Mapping Account	Mapping tài khoản	13	/accounting/account-mapping	fas fa-link me-2	99	accounting	\N	t	2026-03-17 06:49:16.240265
39	ACCOUNTING_TT99_GROUP	Báo cáo	13	/accounting/balance-sheet	fas fa-file-invoice-dollar	65	accounting		t	2026-04-09 07:29:19.90271
22	SETTINGS	Cài đặt	\N	None	fas fa-cogs	9	settings		t	2026-03-17 06:49:16.313879
43	ACCOUNTING_TT99_DETAIL_LEDGER	Sổ chi tiết (TK 131)	13	/accounting/detail-ledger/131	fas fa-list-alt	69	accounting		t	2026-04-09 07:29:19.969086
40	ACCOUNTING_TT99_BALANCE_SHEET	TT99 - Bảng cân đối kế toán	13	/accounting/balance-sheet	fas fa-scale-balanced	66	accounting		f	2026-04-09 07:29:19.951863
2	WAREHOUSE	Kho hàng & Hàng hóa	\N	\N	fas fa-warehouse	2	\N		t	2026-03-17 06:49:16.24791
44	SALES_QUOTATIONS	Bảng báo giá	10	/quotations	fas fa-file-signature	54	quotations		t	2026-05-29 05:25:46.465773
45	ECOMMERCE_ROOT	E-commerce	\N	\N	fas fa-store	58	ecommerce		t	2026-05-31 15:20:27.765031
41	ACCOUNTING_TT99_INCOME_STATEMENT	Báo cáo KQKD	13	/accounting/income-statement	fas fa-chart-line	67	accounting		t	2026-04-09 07:29:19.957224
3	PRODUCTS	Hàng hóa	2	/products/	fas fa-box	21	products		t	2026-03-17 06:49:16.250448
9	STOCK_IN	Phiếu nhập kho	7	/stock-in/	fas fa-arrow-circle-down	32	stock_in		t	2026-03-17 06:49:16.272178
10	SALES	Bán hàng	\N	\N	fas fa-store	4	\N		t	2026-03-17 06:49:16.275459
11	CUSTOMERS	Khách hàng	10	/customers/	fas fa-users	41	customers		t	2026-03-17 06:49:16.279075
12	STOCK_OUT	Phiếu xuất kho	10	/stock-out/	fas fa-arrow-circle-up	42	stock_out		t	2026-03-17 06:49:16.282821
27	OPENING_STOCK	Tồn đầu kỳ	2	/opening-stock/	fas fa-box-open	25	opening_stock		t	2026-03-17 06:49:16.323642
\.


--
-- TOC entry 3435 (class 0 OID 67961)
-- Dependencies: 205
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.notifications (id, code, name, message_template, noti_type, module, is_active, created_at) FROM stdin;
1	STOCK_IN_CREATED	Tạo phiếu nhập thành công	Phiếu nhập {code} đã được tạo thành công!	success	warehouse	t	2026-03-17 06:49:16.342084
2	STOCK_IN_CONFIRMED	Xác nhận nhập kho	Phiếu nhập {code} đã được xác nhận. Tồn kho đã cập nhật.	success	warehouse	t	2026-03-17 06:49:16.344122
3	STOCK_IN_CANCELLED	Hủy phiếu nhập	Phiếu nhập {code} đã bị hủy.	warning	warehouse	t	2026-03-17 06:49:16.346853
4	STOCK_OUT_CREATED	Tạo phiếu xuất thành công	Phiếu xuất {code} đã được tạo!	success	warehouse	t	2026-03-17 06:49:16.348639
5	STOCK_OUT_CONFIRMED	Xác nhận xuất kho	Phiếu xuất {code} đã xác nhận. Tồn kho đã cập nhật.	success	warehouse	t	2026-03-17 06:49:16.349909
6	LOW_STOCK_ALERT	Cảnh báo hàng sắp hết	Hàng hóa {product_name} còn {quantity} {unit} - dưới mức tối thiểu!	warning	inventory	t	2026-03-17 06:49:16.351054
7	DEBT_PAYMENT_SUCCESS	Thanh toán thành công	Đã ghi nhận thanh toán {amount} VND cho {partner_name}.	success	accounting	t	2026-03-17 06:49:16.352916
8	DEBT_OVERDUE	Công nợ quá hạn	Công nợ của {partner_name} đã quá hạn {days} ngày! Số dư: {balance} VND.	error	accounting	t	2026-03-17 06:49:16.354146
9	IMPORT_SUCCESS	Import dữ liệu thành công	Import thành công {count} bản ghi từ file Excel.	success	system	t	2026-03-17 06:49:16.35534
10	IMPORT_ERROR	Lỗi import dữ liệu	Có {error_count} lỗi trong quá trình import. Vui lòng kiểm tra lại file.	warning	system	t	2026-03-17 06:49:16.356508
12	PRODUCT_CREATED	Thêm hàng hóa	Hàng hóa {code} - {name} đã được thêm vào hệ thống.	success	warehouse	t	2026-03-17 06:49:16.358774
13	CUSTOMER_CREATED	Thêm khách hàng	Khách hàng {code} - {name} đã được thêm.	success	sales	t	2026-03-17 06:49:16.359886
14	SUPPLIER_CREATED	Thêm nhà cung cấp	Nhà cung cấp {code} - {name} đã được thêm.	success	purchase	t	2026-03-17 06:49:16.36169
11	LOGIN_SUCCESS	Đăng nhập thành công	Chào mừng {name} đã đăng nhập hệ thống ERP-VIET!	success	auth	t	2026-03-17 06:49:16.357653
\.


--
-- TOC entry 3504 (class 0 OID 99914)
-- Dependencies: 274
-- Data for Name: online_order_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.online_order_items (id, online_order_id, listing_id, product_id, product_name_snapshot, quantity, unit_price, amount, created_at) FROM stdin;
19	18	200	472	Giấy trắng ( Smartist ) - 70gsm - A3	10.000	70000.00	700000.00	2026-06-12 16:38:45.267679
20	19	110	388	Bìa lỗ 500G	20.000	35000.00	700000.00	2026-06-12 17:04:44.917994
21	20	110	388	Bìa lỗ 500G	1.000	35000.00	35000.00	2026-06-18 10:33:36.45153
22	21	110	388	Bìa lỗ 500G	10.000	35000.00	350000.00	2026-06-18 11:19:46.587722
23	22	110	388	Bìa lỗ 500G	1.000	35000.00	35000.00	2026-06-19 15:41:15.966404
24	23	110	388	Bìa lỗ 500G	5.000	35000.00	175000.00	2026-07-16 07:04:45.199745
25	24	110	388	Bìa lỗ 500G	5.000	35000.00	175000.00	2026-07-16 07:06:51.121296
26	25	110	388	Bìa lỗ 500G	1.000	35000.00	35000.00	2026-07-16 07:06:51.175402
27	26	110	388	Bìa lỗ 500G	5.000	35000.00	175000.00	2026-07-16 08:44:50.334855
28	27	110	388	Bìa lỗ 500G	2.000	35000.00	70000.00	2026-07-16 10:18:22.405255
29	28	110	388	Bìa lỗ 500G	2.000	35000.00	70000.00	2026-07-16 10:19:31.080055
30	29	110	388	Bìa lỗ 500G	2.000	35000.00	70000.00	2026-07-16 10:21:38.843415
31	30	110	388	Bìa lỗ 500G	2.000	35000.00	70000.00	2026-07-16 10:23:22.627448
32	31	110	388	Bìa lỗ 500G	2.000	35000.00	70000.00	2026-07-16 10:24:14.742944
33	32	110	388	Bìa lỗ 500G	2.000	35000.00	70000.00	2026-07-16 10:26:27.870892
34	33	110	388	Bìa lỗ 500G	2.000	35000.00	70000.00	2026-07-16 10:27:49.854923
35	34	110	388	Bìa lỗ 500G	1.000	35000.00	35000.00	2026-07-16 10:29:44.459689
36	35	200	472	Giấy trắng ( Smartist ) - 70gsm - A3	2.000	70000.00	140000.00	2026-07-16 11:49:39.372961
37	36	200	472	Giấy trắng ( Smartist ) - 70gsm - A3	1.000	70000.00	70000.00	2026-07-16 11:51:25.242073
38	37	200	472	Giấy trắng ( Smartist ) - 70gsm - A3	1.000	70000.00	70000.00	2026-07-16 11:54:20.930103
\.


--
-- TOC entry 3502 (class 0 OID 99872)
-- Dependencies: 272
-- Data for Name: online_orders; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.online_orders (id, code, session_id, customer_id, promotion_id, customer_name, customer_phone, customer_email, shipping_address, subtotal, discount_amount, shipping_fee, vat_amount, total_amount, status, sync_status, sync_error, stock_out_id, note, created_at, updated_at, synced_at, erp_status, erp_note, web_customer_id, payment_method) FROM stdin;
18	WEB-260612-0001	48	\N	\N	Nguyen Van A	0903123456	nguyenvana@mail.com	123 DUONG ABC	700000.00	0.00	0.00	0.00	700000.00	new	synced	\N	15		2026-06-12 16:38:45.261823	2026-06-12 16:39:38.799073	2026-06-12 16:38:57.664206	Đã xuất kho	Đồng bộ tự động từ phiếu xuất PX-WEB-260612-0001 lúc 12/06/2026 23:39.	3	\N
19	WEB-260613-0001	49	\N	\N	TRẦN VĂN B	012345678	tranvanb@mail.com	123 duong cns cnd	700000.00	0.00	0.00	0.00	700000.00	new	synced	\N	17		2026-06-12 17:04:44.913403	2026-06-13 06:08:28.62988	2026-06-12 17:04:57.90052	Đã xuất kho	Đồng bộ tự động từ phiếu xuất PX-WEB-260613-0001 lúc 13/06/2026 13:08.	4	\N
20	WEB-260618-0001	50	\N	\N	TRẦN QUỐC VIỆT	0935790357	caytrebmt@gmail.com	123 DUONG ABC	35000.00	0.00	0.00	0.00	35000.00	new	pending	\N	\N		2026-06-18 10:33:36.446505	2026-06-18 10:33:36.44651	\N	\N	\N	\N	\N
21	WEB-260618-0002	50	\N	\N	TRAN QUOC VIET	0935790357	cg3090@gmail.com	123 duong cns cnd	350000.00	0.00	0.00	0.00	350000.00	new	pending	\N	\N		2026-06-18 11:19:46.583568	2026-06-18 11:19:46.583573	\N	\N	\N	\N	\N
22	WEB-260619-0001	51	\N	\N	Nguyen Van A	0903123456	nguyenvana@mail.com		35000.00	0.00	0.00	0.00	35000.00	new	pending	\N	\N		2026-06-19 15:41:15.961933	2026-06-19 15:41:15.961938	\N	\N	\N	3	\N
26	WEB-260716-0004	54	\N	\N	Nguyen Van A			123 Test Street, HCMC	175000.00	0.00	0.00	17500.00	192500.00	new	synced	\N	22		2026-07-16 08:44:50.325251	2026-07-16 10:05:26.709191	2026-07-16 10:05:26.677075	Đã xuất kho	Đồng bộ tự động từ phiếu xuất PX-260716-001 lúc 16/07/2026 17:05.	3	\N
25	WEB-260716-0003	55	\N	\N	Khách online	\N	\N		35000.00	0.00	0.00	3500.00	38500.00	new	synced	\N	23		2026-07-16 07:06:51.169003	2026-07-16 10:05:35.25144	2026-07-16 10:05:35.247102	Đã xuất kho	Đồng bộ tự động từ phiếu xuất PX-260716-002 lúc 16/07/2026 17:05.	\N	\N
24	WEB-260716-0002	54	\N	\N	Nguyen Van A			123 Test St	175000.00	0.00	0.00	17500.00	192500.00	new	synced	\N	24		2026-07-16 07:06:51.114188	2026-07-16 10:05:38.573542	2026-07-16 10:05:38.569324	Đã xuất kho	Đồng bộ tự động từ phiếu xuất PX-260716-003 lúc 16/07/2026 17:05.	3	\N
23	WEB-260716-0001	54	\N	\N	Nguyen Van A			123 Test St	175000.00	0.00	0.00	17500.00	192500.00	new	synced	\N	25		2026-07-16 07:04:45.13397	2026-07-16 10:05:42.417874	2026-07-16 10:05:42.410166	Đã xuất kho	Đồng bộ tự động từ phiếu xuất PX-260716-004 lúc 16/07/2026 17:05.	3	\N
27	WEB-260716-0005	63	291	\N	Updated Name			123 Web Street	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N		2026-07-16 10:18:22.39859	2026-07-16 10:18:22.398596	\N	\N	\N	13	\N
28	WEB-260716-0006	64	292	\N	Updated Name			123 Web Street	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N		2026-07-16 10:19:31.070891	2026-07-16 10:19:31.070917	\N	\N	\N	14	\N
29	WEB-260716-0007	65	293	\N	Updated Name			123 Web Street	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N		2026-07-16 10:21:38.83786	2026-07-16 10:21:38.837872	\N	\N	\N	15	\N
30	WEB-260716-0008	66	294	\N	Updated Name			123 Web Street	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N		2026-07-16 10:23:22.62167	2026-07-16 10:23:22.621682	\N	\N	\N	16	\N
31	WEB-260716-0009	67	295	\N	Updated Name			123 Web Street	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N		2026-07-16 10:24:14.739683	2026-07-16 10:24:14.73969	\N	\N	\N	17	\N
32	WEB-260716-0010	69	296	\N	Updated Name			123 Web Street	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N		2026-07-16 10:26:27.862236	2026-07-16 10:26:27.862242	\N	\N	\N	18	\N
33	WEB-260716-0011	70	297	\N	Updated Name			123 Web Street	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N		2026-07-16 10:27:49.848027	2026-07-16 10:27:49.848033	\N	\N	\N	19	\N
34	WEB-260716-0012	71	298	\N	Final Test			123 Test	35000.00	0.00	0.00	3500.00	38500.00	new	synced	\N	26		2026-07-16 10:29:44.451266	2026-07-16 10:32:19.827516	2026-07-16 10:32:19.820826	Đã xuất kho	Đồng bộ tự động từ phiếu xuất PX-260716-005 lúc 16/07/2026 17:32.	20	\N
35	WEB-260716-0013	54	299	\N	Nguyen Van A	0909123456	a@example.com	123 Test St	140000.00	0.00	0.00	14000.00	154000.00	new	pending	\N	\N	Test order from webshop	2026-07-16 11:49:39.36573	2026-07-16 11:49:39.365741	\N	\N	\N	3	COD
36	WEB-260716-0014	54	299	\N	Nguyen Van A	0909123456	a@example.com	123 Test St	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N	Test order from webshop	2026-07-16 11:51:25.238493	2026-07-16 11:51:25.2385	\N	\N	\N	3	COD
37	WEB-260716-0015	54	299	\N	Nguyen Van A	0909123456	a@example.com	123 Test St	70000.00	0.00	0.00	7000.00	77000.00	new	pending	\N	\N	Test order from webshop	2026-07-16 11:54:20.915676	2026-07-16 11:54:20.915692	\N	\N	\N	3	COD
\.


--
-- TOC entry 3467 (class 0 OID 68231)
-- Dependencies: 237
-- Data for Name: opening_stocks; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.opening_stocks (id, period_date, product_id, warehouse_id, quantity, unit_cost, amount, note, is_posted, created_by, created_at) FROM stdin;
103	2026-05-01	479	2	100000.000	0.00	0.00		t	1	2026-05-28 13:49:53.510274
1	2026-05-01	377	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.576847
2	2026-05-01	378	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.584061
3	2026-05-01	379	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.587926
4	2026-05-01	380	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.591668
5	2026-05-01	381	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.595
6	2026-05-01	388	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.598121
7	2026-05-01	389	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.601685
8	2026-05-01	390	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.605386
9	2026-05-01	382	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.608218
10	2026-05-01	383	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.611364
11	2026-05-01	384	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.614777
12	2026-05-01	385	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.618178
13	2026-05-01	386	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.622051
14	2026-05-01	387	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.625321
15	2026-05-01	391	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.628246
16	2026-05-01	392	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.63194
17	2026-05-01	393	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.636155
18	2026-05-01	394	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.640017
19	2026-05-01	395	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.644331
20	2026-05-01	396	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.648082
21	2026-05-01	397	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.65248
22	2026-05-01	398	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.655651
23	2026-05-01	399	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.658912
24	2026-05-01	400	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.662185
25	2026-05-01	401	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.665536
26	2026-05-01	402	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.669421
27	2026-05-01	403	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.672886
28	2026-05-01	404	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.676101
29	2026-05-01	405	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.67939
30	2026-05-01	406	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.682546
31	2026-05-01	407	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.687375
32	2026-05-01	414	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.691187
33	2026-05-01	408	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.694617
34	2026-05-01	409	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.697752
35	2026-05-01	410	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.70201
36	2026-05-01	411	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.70585
37	2026-05-01	412	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.708943
38	2026-05-01	413	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.712516
39	2026-05-01	415	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.7157
40	2026-05-01	416	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.719549
41	2026-05-01	417	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.722906
42	2026-05-01	418	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.726191
43	2026-05-01	419	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.729838
44	2026-05-01	420	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.733004
45	2026-05-01	421	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.737579
46	2026-05-01	423	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.74075
47	2026-05-01	424	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.744007
48	2026-05-01	422	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.747278
49	2026-05-01	425	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.751053
50	2026-05-01	426	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.755477
51	2026-05-01	427	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.759674
52	2026-05-01	428	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.763684
53	2026-05-01	429	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.768158
54	2026-05-01	430	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.772561
55	2026-05-01	431	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.777194
56	2026-05-01	432	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.782043
57	2026-05-01	433	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.786971
58	2026-05-01	434	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.790553
59	2026-05-01	435	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.795473
60	2026-05-01	436	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.800618
61	2026-05-01	437	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.805183
62	2026-05-01	438	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.809313
63	2026-05-01	439	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.812505
64	2026-05-01	440	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.816237
65	2026-05-01	441	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.820067
66	2026-05-01	442	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.823145
67	2026-05-01	443	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.826497
68	2026-05-01	444	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.829919
69	2026-05-01	445	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.833555
70	2026-05-01	446	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.837031
71	2026-05-01	447	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.840208
72	2026-05-01	448	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.84346
73	2026-05-01	450	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.847345
74	2026-05-01	449	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.850887
75	2026-05-01	451	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.854777
76	2026-05-01	452	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.858164
77	2026-05-01	453	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.862626
78	2026-05-01	454	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.867735
79	2026-05-01	455	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.871976
80	2026-05-01	456	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.876259
81	2026-05-01	457	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.880767
82	2026-05-01	458	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.885182
83	2026-05-01	459	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.889005
84	2026-05-01	460	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.893364
85	2026-05-01	461	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.897637
86	2026-05-01	462	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.902271
87	2026-05-01	463	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.906806
88	2026-05-01	464	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.912699
89	2026-05-01	465	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.917591
90	2026-05-01	466	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.922547
91	2026-05-01	467	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.926045
92	2026-05-01	468	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.929283
93	2026-05-01	469	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.932547
94	2026-05-01	470	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.937183
95	2026-05-01	471	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.940346
96	2026-05-01	472	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.943788
97	2026-05-01	473	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.946971
98	2026-05-01	474	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.950749
99	2026-05-01	475	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.954225
100	2026-05-01	476	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.957511
101	2026-05-01	477	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.960808
102	2026-05-01	478	2	100000.000	0.00	0.00	\N	t	1	2026-05-27 10:56:24.963749
\.


--
-- TOC entry 3508 (class 0 OID 102052)
-- Dependencies: 278
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.product_images (id, product_id, image_url, image_name, sort_order, is_main, created_at) FROM stdin;
5	472	/static/uploads/products/SMARTISTA370_1.jpg	SMARTISTA370_1.jpg	1	t	2026-06-12 04:59:14.847792
6	472	/static/uploads/products/SMARTISTA370_2.jpg	SMARTISTA370_2.jpg	2	f	2026-06-12 04:59:14.921731
8	472	/static/uploads/products/SMARTISTA370_4.jpg	SMARTISTA370_4.jpg	4	f	2026-06-12 04:59:15.024602
9	388	/static/uploads/products/BIALO500G_1.jpg	BIALO500G_1.jpg	1	t	2026-06-12 17:03:28.352805
10	388	/static/uploads/products/BIALO500G_2.jpg	BIALO500G_2.jpg	2	f	2026-06-12 17:03:28.909061
11	450	/static/uploads/products/NHUAYIDUA3_1.jpg	NHUAYIDUA3_1.jpg	1	t	2026-07-16 12:43:48.758173
12	449	/static/uploads/products/NHUAYIDUA4_1.jpg	NHUAYIDUA4_1.jpg	1	t	2026-07-16 12:44:05.920254
13	451	/static/uploads/products/NOTE3X2V_1.jpg	NOTE3X2V_1.jpg	1	t	2026-07-16 12:53:35.989146
15	435	/static/uploads/products/KEPBUOM15_1.jpg	KEPBUOM15_1.jpg	1	t	2026-07-16 14:47:36.355956
16	479	/static/uploads/products/BIALO400G_1.jpg	BIALO400G_1.jpg	1	t	2026-07-17 11:41:27.532383
17	389	/static/uploads/products/BIALO600G_1.jpg	BIALO600G_1.jpg	1	t	2026-07-17 11:41:46.024469
18	390	/static/uploads/products/BIALO700G_1.jpg	BIALO700G_1.jpg	1	t	2026-07-17 11:42:04.166889
19	408	/static/uploads/products/DOUBLEAA3_1.jpg	DOUBLEAA3_1.jpg	1	t	2026-07-17 11:42:25.967604
20	436	/static/uploads/products/KEPBUOM19_1.jpg	KEPBUOM19_1.jpg	1	t	2026-07-17 11:43:03.497275
21	437	/static/uploads/products/KEPBUOM25_1.jpg	KEPBUOM25_1.jpg	1	t	2026-07-17 11:43:17.106293
22	438	/static/uploads/products/KEPBUOM32_1.jpg	KEPBUOM32_1.jpg	1	t	2026-07-17 11:43:35.965295
23	439	/static/uploads/products/KEPBUOM41_1.jpg	KEPBUOM41_1.jpg	1	t	2026-07-17 11:43:57.115429
24	441	/static/uploads/products/KEPBUOMMAU15_1.jpg	KEPBUOMMAU15_1.jpg	1	t	2026-07-17 11:44:26.428416
\.


--
-- TOC entry 3490 (class 0 OID 99732)
-- Dependencies: 260
-- Data for Name: product_listings; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.product_listings (id, product_id, slug, web_title, web_description, web_price, compare_at_price, image_url, seo_title, seo_description, stock_cached, stock_synced_at, is_published, created_at, updated_at, retail_price, contact_for_price) FROM stdin;
104	377	bamkims10-b-m-kim-s-10	Bấm kim số 10	None	3000.00	\N	None	Bấm kim số 10	\N	100000.000	2026-06-03 16:51:46.917111	f	2026-06-03 16:51:46.935568	2026-06-03 16:51:46.935573	\N	f
105	378	biadoublea20laxd-b-a-l-double-a-20-xanh-d-ng	Bìa lá Double A 20 xanh dương	\N	0.00	\N	\N	Bìa lá Double A 20 xanh dương	\N	100000.000	2026-06-03 16:51:46.938685	f	2026-06-03 16:51:46.939297	2026-06-03 16:51:46.939301	\N	f
106	379	biadoublea40laxd-b-a-l-double-a-40-xanh-d-ng	Bìa lá Double A 40 xanh dương	\N	0.00	\N	\N	Bìa lá Double A 40 xanh dương	\N	100000.000	2026-06-03 16:51:46.941872	f	2026-06-03 16:51:46.943111	2026-06-03 16:51:46.943122	\N	f
107	380	biadoublea40laxdcc-b-a-l-cao-c-p-double-a-40-xanh-d-ng	Bìa lá cao cấp Double A 40 xanh dương	\N	0.00	\N	\N	Bìa lá cao cấp Double A 40 xanh dương	\N	100000.000	2026-06-03 16:51:46.945555	f	2026-06-03 16:51:46.946415	2026-06-03 16:51:46.94642	\N	f
108	381	biadoublea60laxdcc-b-a-l-cao-c-p-double-a-60-xanh-d-ng	Bìa lá cao cấp Double A 60 xanh dương	None	0.00	\N	\N	Bìa lá cao cấp Double A 60 xanh dương	\N	100000.000	2026-06-03 16:51:46.949132	f	2026-06-03 16:51:46.949811	2026-06-03 16:51:46.949815	\N	f
111	389	bialo600g-b-a-l-600g	Bìa lỗ 600G	None	0.00	\N	\N	Bìa lỗ 600G	\N	100000.000	2026-06-03 16:51:46.956331	f	2026-06-03 16:51:46.956917	2026-06-03 16:51:46.956922	\N	f
112	390	bialo700g-b-a-l-700g	Bìa lỗ 700G	None	0.00	\N	\N	Bìa lỗ 700G	\N	100000.000	2026-06-03 16:51:46.960331	f	2026-06-03 16:51:46.961159	2026-06-03 16:51:46.961163	\N	f
113	382	biamaua470-b-a-m-u-a4-70	Bìa màu A4 70	\N	0.00	\N	\N	Bìa màu A4 70	\N	100000.000	2026-06-03 16:51:46.963456	f	2026-06-03 16:51:46.964135	2026-06-03 16:51:46.96414	\N	f
114	383	biamaua480-b-a-m-u-a4-80	Bìa màu A4 80	\N	0.00	\N	\N	Bìa màu A4 80	\N	100000.000	2026-06-03 16:51:46.965923	f	2026-06-03 16:51:46.966526	2026-06-03 16:51:46.96653	\N	f
115	384	bianuta4-b-a-n-t-a4	Bìa nút A4	\N	0.00	\N	\N	Bìa nút A4	\N	100000.000	2026-06-03 16:51:46.968315	f	2026-06-03 16:51:46.968927	2026-06-03 16:51:46.968931	\N	f
116	385	bianuta4d-b-a-n-t-a4-d-y	Bìa nút A4 dày	\N	0.00	\N	\N	Bìa nút A4 dày	\N	100000.000	2026-06-03 16:51:46.970607	f	2026-06-03 16:51:46.971238	2026-06-03 16:51:46.971242	\N	f
117	386	bianutf4-b-a-n-t-f4	Bìa nút F4	\N	0.00	\N	\N	Bìa nút F4	\N	100000.000	2026-06-03 16:51:46.973046	f	2026-06-03 16:51:46.97367	2026-06-03 16:51:46.973674	\N	f
118	387	biatranga4-gi-y-b-a-tr-ng-a4	Giấy Bìa Trắng A4	\N	0.00	\N	\N	Giấy Bìa Trắng A4	\N	100000.000	2026-06-03 16:51:46.976871	f	2026-06-03 16:51:46.977628	2026-06-03 16:51:46.977632	\N	f
119	391	bristol-gi-y-bristol	Giấy Bristol	\N	0.00	\N	\N	Giấy Bristol	\N	100000.000	2026-06-03 16:51:46.979991	f	2026-06-03 16:51:46.980659	2026-06-03 16:51:46.980663	\N	f
120	392	butbitl027-b-t-bi-tl027	Bút bi TL027	\N	0.00	\N	\N	Bút bi TL027	\N	100000.000	2026-06-03 16:51:46.982413	f	2026-06-03 16:51:46.983073	2026-06-03 16:51:46.983078	\N	f
121	393	butbitl027h-b-t-bi-tl027-h-p	Bút bi TL027 (hộp)	\N	0.00	\N	\N	Bút bi TL027 (hộp)	\N	100000.000	2026-06-03 16:51:46.985037	f	2026-06-03 16:51:46.985659	2026-06-03 16:51:46.985663	\N	f
122	394	butbitl08-b-t-bi-tl08	Bút bi TL08	\N	0.00	\N	\N	Bút bi TL08	\N	100000.000	2026-06-03 16:51:46.987417	f	2026-06-03 16:51:46.988102	2026-06-03 16:51:46.988106	\N	f
123	395	butbitl105-b-t-bi-tl-105	Bút bi TL-105	\N	0.00	\N	\N	Bút bi TL-105	\N	100000.000	2026-06-03 16:51:46.989889	f	2026-06-03 16:51:46.990475	2026-06-03 16:51:46.990479	\N	f
124	396	butdahl03-b-t-d-quang-hl03	Bút dạ quang HL03	\N	0.00	\N	\N	Bút dạ quang HL03	\N	100000.000	2026-06-03 16:51:46.993948	f	2026-06-03 16:51:46.994846	2026-06-03 16:51:46.994851	\N	f
125	397	butlbangwb-03-b-t-l-ng-b-ng-wb-03	Bút lông bảng WB-03	\N	0.00	\N	\N	Bút lông bảng WB-03	\N	100000.000	2026-06-03 16:51:46.997303	f	2026-06-03 16:51:46.998015	2026-06-03 16:51:46.998019	\N	f
126	398	butldaupm04-b-t-l-ng-d-u-pm04-10c-h	Bút lông dầu PM04 (10c/h)	\N	0.00	\N	\N	Bút lông dầu PM04 (10c/h)	\N	100000.000	2026-06-03 16:51:46.999874	f	2026-06-03 16:51:47.000477	2026-06-03 16:51:47.000481	\N	f
127	399	butldaupm04h-b-t-l-ng-d-u-pm04-h-p	Bút lông dầu - PM04 (hộp)	\N	0.00	\N	\N	Bút lông dầu - PM04 (hộp)	\N	100000.000	2026-06-03 16:51:47.002176	f	2026-06-03 16:51:47.002764	2026-06-03 16:51:47.002769	\N	f
128	400	butldaupm09-b-t-l-ng-d-u-pm09-10c-h	Bút lông dầu PM09 (10c/h)	\N	0.00	\N	\N	Bút lông dầu PM09 (10c/h)	\N	100000.000	2026-06-03 16:51:47.004422	f	2026-06-03 16:51:47.005005	2026-06-03 16:51:47.005009	\N	f
129	401	butldaupm09h-b-t-l-ng-d-u-pm09-h-p	Bút lông dầu PM09 (hộp)	\N	0.00	\N	\N	Bút lông dầu PM09 (hộp)	\N	100000.000	2026-06-03 16:51:47.006642	f	2026-06-03 16:51:47.007465	2026-06-03 16:51:47.007475	\N	f
130	402	buttlf0-03-b-t-tl-f0-03	Bút TL F0.03	\N	0.00	\N	\N	Bút TL F0.03	\N	100000.000	2026-06-03 16:51:47.011226	f	2026-06-03 16:51:47.011962	2026-06-03 16:51:47.011966	\N	f
131	403	butxoacp02-bu-t-x-a-cp02	Bút xóa CP02	\N	0.00	\N	\N	Bút xóa CP02	\N	100000.000	2026-06-03 16:51:47.013872	f	2026-06-03 16:51:47.01462	2026-06-03 16:51:47.014625	\N	f
132	404	carbonlessimp2-gi-y-carbonless-imp-k210-2-2l	Giấy Carbonless IMP K210/2 - 2L	\N	0.00	\N	\N	Giấy Carbonless IMP K210/2 - 2L	\N	100000.000	2026-06-03 16:51:47.01648	f	2026-06-03 16:51:47.017086	2026-06-03 16:51:47.017091	\N	f
133	405	couche-gi-y-couche	Giấy Couche	\N	0.00	\N	\N	Giấy Couche	\N	100000.000	2026-06-03 16:51:47.019014	f	2026-06-03 16:51:47.019645	2026-06-03 16:51:47.01965	\N	f
134	406	couchedl300-gi-y-couche-l-300	Giấy Couche ĐL 300	\N	0.00	\N	\N	Giấy Couche ĐL 300	\N	100000.000	2026-06-03 16:51:47.021343	f	2026-06-03 16:51:47.021948	2026-06-03 16:51:47.021952	\N	f
135	407	couchedl70-gi-y-couche-l-70	Giấy Couche ĐL 70	\N	0.00	\N	\N	Giấy Couche ĐL 70	\N	100000.000	2026-06-03 16:51:47.023657	f	2026-06-03 16:51:47.024789	2026-06-03 16:51:47.024798	\N	f
136	414	doublea480-gi-y-a480-double-a	Giấy A480 double A	\N	0.00	\N	\N	Giấy A480 double A	\N	100000.000	2026-06-03 16:51:47.028338	f	2026-06-03 16:51:47.029015	2026-06-03 16:51:47.029019	\N	f
138	409	doubleaa370-gi-y-tr-ng-double-a-70gsm-a3	Giấy trắng (Double A) - 70gsm - A3		0.00	\N	\N	Giấy trắng (Double A) - 70gsm - A3	\N	100000.000	2026-06-03 16:51:47.033197	f	2026-06-03 16:51:47.033775	2026-06-03 16:51:47.03378	\N	f
139	410	doubleaa380-gi-y-a3-80-double-a	Giấy A3 80 Double A		0.00	\N	\N	Giấy A3 80 Double A	\N	100000.000	2026-06-03 16:51:47.035443	f	2026-06-03 16:51:47.036035	2026-06-03 16:51:47.036039	\N	f
140	411	doubleaa470-gi-y-doublea-a4-70	Giấy DoubleA A4 70	\N	0.00	\N	\N	Giấy DoubleA A4 70	\N	100000.000	2026-06-03 16:51:47.037819	f	2026-06-03 16:51:47.038445	2026-06-03 16:51:47.03845	\N	f
141	412	doubleaa480-gi-y-doublea-a4-80	Giấy DoubleA A4 80	\N	0.00	\N	\N	Giấy DoubleA A4 80	\N	100000.000	2026-06-03 16:51:47.040158	f	2026-06-03 16:51:47.04103	2026-06-03 16:51:47.04104	\N	f
142	413	doubleaa570-gi-y-tr-ng-double-a-70gsm-a5	Giấy trắng (Double A) 70gsm - A5	\N	0.00	\N	\N	Giấy trắng (Double A) 70gsm - A5	\N	100000.000	2026-06-03 16:51:47.045089	f	2026-06-03 16:51:47.045913	2026-06-03 16:51:47.04592	\N	f
143	415	duplex-gi-y-duplex	Giấy Duplex	\N	0.00	\N	\N	Giấy Duplex	\N	100000.000	2026-06-03 16:51:47.048376	f	2026-06-03 16:51:47.049077	2026-06-03 16:51:47.049082	\N	f
144	416	duplex270-gi-y-duplex-270	Giấy Duplex 270	\N	0.00	\N	\N	Giấy Duplex 270	\N	100000.000	2026-06-03 16:51:47.051096	f	2026-06-03 16:51:47.051761	2026-06-03 16:51:47.051765	\N	f
145	417	duplex350-gi-y-duplex-350	Giấy Duplex 350	\N	0.00	\N	\N	Giấy Duplex 350	\N	100000.000	2026-06-03 16:51:47.053758	f	2026-06-03 16:51:47.05439	2026-06-03 16:51:47.054394	\N	f
146	418	duplexa3300-gi-y-a3-duplex-300	Giấy A3 Duplex 300		0.00	\N	\N	Giấy A3 Duplex 300	\N	100000.000	2026-06-03 16:51:47.056135	f	2026-06-03 16:51:47.056716	2026-06-03 16:51:47.05672	\N	f
147	419	excela370-gi-y-excel-70-a3	Giấy Excel 70 A3		0.00	\N	\N	Giấy Excel 70 A3	\N	100000.000	2026-06-03 16:51:47.060215	f	2026-06-03 16:51:47.061021	2026-06-03 16:51:47.061026	\N	f
148	420	excela470-gi-y-a470-excel	Giấy A470 excel	\N	0.00	\N	\N	Giấy A470 excel	\N	100000.000	2026-06-03 16:51:47.063031	f	2026-06-03 16:51:47.063648	2026-06-03 16:51:47.063652	\N	f
149	421	f0mau70-gi-y-f0-m-u-70	Giấy F0 màu 70	\N	0.00	\N	\N	Giấy F0 màu 70	\N	100000.000	2026-06-03 16:51:47.065384	f	2026-06-03 16:51:47.065997	2026-06-03 16:51:47.066001	\N	f
150	423	giaya370-gi-y-a3-70	Giấy A3 70	None	0.00	\N	\N	Giấy A3 70	\N	100000.000	2026-06-03 16:51:47.067716	f	2026-06-03 16:51:47.068386	2026-06-03 16:51:47.06839	\N	f
151	424	giaya380-gi-y-a3-80	Giấy A3 80		0.00	\N	\N	Giấy A3 80	\N	100000.000	2026-06-03 16:51:47.070115	f	2026-06-03 16:51:47.070682	2026-06-03 16:51:47.070687	\N	f
110	388	bialo500g-b-a-l-500g	Bìa lỗ 500G	None	35000.00	\N	\N	Bìa lỗ 500G	\N	100000.000	2026-06-03 16:51:46.954037	t	2026-06-03 16:51:46.954651	2026-06-12 17:03:35.689557	\N	f
137	408	doubleaa3-gi-y-doublea-a3-70	Giấy DoubleA A3 70		0.00	\N	\N	Giấy DoubleA A3 70	\N	100000.000	2026-06-03 16:51:47.030859	t	2026-06-03 16:51:47.031479	2026-07-20 10:12:06.739511	\N	f
152	422	gmau160-gi-y-m-u-160	Giấy màu 160	\N	0.00	\N	\N	Giấy màu 160	\N	100000.000	2026-06-03 16:51:47.07233	f	2026-06-03 16:51:47.073022	2026-06-03 16:51:47.07303	\N	f
153	425	goldenstara470-gi-y-golden-star-70-a4-2550-ram	Giấy Golden Star 70 A4 (2550 RAM)	\N	0.00	\N	\N	Giấy Golden Star 70 A4 (2550 RAM)	\N	100000.000	2026-06-03 16:51:47.07697	f	2026-06-03 16:51:47.07774	2026-06-03 16:51:47.077744	\N	f
154	426	ideaa470-gi-y-tr-ng-idea-70gsm-a4	Giấy trắng Idea 70gsm, A4	\N	0.00	\N	\N	Giấy trắng Idea 70gsm, A4	\N	100000.000	2026-06-03 16:51:47.079828	f	2026-06-03 16:51:47.080438	2026-06-03 16:51:47.080442	\N	f
155	427	ideaa480-gi-y-a480-idea	Giấy A480 Idea	\N	0.00	\N	\N	Giấy A480 Idea	\N	100000.000	2026-06-03 16:51:47.082213	f	2026-06-03 16:51:47.082802	2026-06-03 16:51:47.082808	\N	f
156	428	ikplusa470-gi-y-ik-plus-a4-70	Giấy IK Plus A4 70	\N	0.00	\N	\N	Giấy IK Plus A4 70	\N	100000.000	2026-06-03 16:51:47.084513	f	2026-06-03 16:51:47.085096	2026-06-03 16:51:47.085101	\N	f
157	429	ikplusa480-gi-y-a480-ik-plus	Giấy A480 IK Plus	\N	0.00	\N	\N	Giấy A480 IK Plus	\N	100000.000	2026-06-03 16:51:47.086729	f	2026-06-03 16:51:47.087361	2026-06-03 16:51:47.087365	\N	f
158	430	ivory-gi-y-ivory	Giấy ivory	\N	0.00	\N	\N	Giấy ivory	\N	100000.000	2026-06-03 16:51:47.089211	f	2026-06-03 16:51:47.089869	2026-06-03 16:51:47.089874	\N	f
159	431	ivorydl270-gi-y-ivory-l-270	Giấy IVORY ĐL 270	\N	0.00	\N	\N	Giấy IVORY ĐL 270	\N	100000.000	2026-06-03 16:51:47.092824	f	2026-06-03 16:51:47.093816	2026-06-03 16:51:47.093821	\N	f
160	432	ivorydl300-gi-y-ivory-l-300	Giấy IVORY ĐL 300	\N	0.00	\N	\N	Giấy IVORY ĐL 300	\N	100000.000	2026-06-03 16:51:47.095907	f	2026-06-03 16:51:47.096567	2026-06-03 16:51:47.096571	\N	f
161	433	ivorydl350-gi-y-ivory-l-350	Giấy IVORY ĐL 350	\N	0.00	\N	\N	Giấy IVORY ĐL 350	\N	100000.000	2026-06-03 16:51:47.098498	f	2026-06-03 16:51:47.099124	2026-06-03 16:51:47.099129	\N	f
162	434	ivorydl400-gi-y-ivory-dl-400	Giấy IVORY DL 400	\N	0.00	\N	\N	Giấy IVORY DL 400	\N	100000.000	2026-06-03 16:51:47.100899	f	2026-06-03 16:51:47.101487	2026-06-03 16:51:47.101492	\N	f
165	437	kepbuom25-k-p-b-m-diamon-white-25mm	Kẹp bướm Diamon White 25mm	None	5300.00	\N	\N	Kẹp bướm Diamon White 25mm	\N	100000.000	2026-06-03 16:51:47.110267	f	2026-06-03 16:51:47.111004	2026-06-03 16:51:47.111009	\N	f
166	438	kepbuom32-k-p-b-m-diamon-white-32mm	Kẹp bướm Diamon White 32mm	None	8300.00	\N	\N	Kẹp bướm Diamon White 32mm	\N	100000.000	2026-06-03 16:51:47.113006	f	2026-06-03 16:51:47.113623	2026-06-03 16:51:47.113627	\N	f
167	439	kepbuom41-k-p-b-m-diamon-white-41mm	Kẹp bướm Diamon White 41mm	None	11500.00	\N	\N	Kẹp bướm Diamon White 41mm	\N	100000.000	2026-06-03 16:51:47.115381	f	2026-06-03 16:51:47.11597	2026-06-03 16:51:47.115974	\N	f
168	440	kepbuom51-k-p-b-m-diamon-white-51mm	Kẹp bướm Diamon White 51mm	None	18500.00	\N	\N	Kẹp bướm Diamon White 51mm	\N	100000.000	2026-06-03 16:51:47.117834	f	2026-06-03 16:51:47.118452	2026-06-03 16:51:47.118456	\N	f
169	441	kepbuommau15-k-p-b-m-diamon-white-m-u-15mm-60	Kẹp bướm Diamon White màu 15mm/60	None	16500.00	\N	\N	Kẹp bướm Diamon White màu 15mm/60	\N	100000.000	2026-06-03 16:51:47.120303	f	2026-06-03 16:51:47.121016	2026-06-03 16:51:47.12102	\N	f
170	442	kepbuommau19-k-p-b-m-diamon-white-m-u-19mm-40	Kẹp bướm Diamon White màu 19mm/40	None	15500.00	\N	\N	Kẹp bướm Diamon White màu 19mm/40	\N	100000.000	2026-06-03 16:51:47.122929	f	2026-06-03 16:51:47.123524	2026-06-03 16:51:47.123529	\N	f
171	443	kepbuommau25-k-p-b-m-diamon-white-m-u-25mm-48	Kẹp bướm Diamon White màu 25mm/48	None	25000.00	\N	\N	Kẹp bướm Diamon White màu 25mm/48	\N	100000.000	2026-06-03 16:51:47.126967	f	2026-06-03 16:51:47.127724	2026-06-03 16:51:47.127729	\N	f
172	444	kepbuommau32-k-p-b-m-diamon-white-m-u-32mm-24	Kẹp bướm Diamon White màu 32mm/24	None	21000.00	\N	\N	Kẹp bướm Diamon White màu 32mm/24	\N	100000.000	2026-06-03 16:51:47.129752	f	2026-06-03 16:51:47.130355	2026-06-03 16:51:47.130359	\N	f
173	445	kepbuommau41-k-p-b-m-diamon-white-m-u-41mm-24	Kẹp bướm Diamon White màu 41mm/24	None	30000.00	\N	\N	Kẹp bướm Diamon White màu 41mm/24	\N	100000.000	2026-06-03 16:51:47.132123	f	2026-06-03 16:51:47.132706	2026-06-03 16:51:47.13271	\N	f
174	446	kepbuommau51-k-p-b-m-diamon-white-m-u-51mm-12	Kẹp bướm Diamon White màu 51mm/12	None	25000.00	\N	\N	Kẹp bướm Diamon White màu 51mm/12	\N	100000.000	2026-06-03 16:51:47.134413	f	2026-06-03 16:51:47.134972	2026-06-03 16:51:47.134976	\N	f
175	447	kimbams10-kim-b-m-s-10	Kim bấm số 10	\N	0.00	\N	\N	Kim bấm số 10	\N	100000.000	2026-06-03 16:51:47.137559	f	2026-06-03 16:51:47.138296	2026-06-03 16:51:47.1383	\N	f
176	448	maua4-gi-y-m-u-a4	Giấy màu A4	\N	0.00	\N	\N	Giấy màu A4	\N	100000.000	2026-06-03 16:51:47.140312	f	2026-06-03 16:51:47.141488	2026-06-03 16:51:47.141494	\N	f
180	452	note3x3sn-gi-y-note-3x3-s-c-ngang	Giấy Note 3x3 sọc ngang	\N	0.00	\N	\N	Giấy Note 3x3 sọc ngang	\N	100000.000	2026-06-03 16:51:47.152319	f	2026-06-03 16:51:47.153164	2026-06-03 16:51:47.153168	\N	f
181	453	note3x3v-gi-y-note-3x3-v-ng	Giấy note 3x3 vàng	\N	0.00	\N	\N	Giấy note 3x3 vàng	\N	100000.000	2026-06-03 16:51:47.155156	f	2026-06-03 16:51:47.15576	2026-06-03 16:51:47.155765	\N	f
182	454	note3x4v-gi-y-note-3x4-v-ng	Giấy note 3x4 vàng	\N	0.00	\N	\N	Giấy note 3x4 vàng	\N	100000.000	2026-06-03 16:51:47.158312	f	2026-06-03 16:51:47.159453	2026-06-03 16:51:47.159463	\N	f
183	455	note3x5v-gi-y-note-3x5-v-ng	Giấy Note 3x5 vàng	\N	0.00	\N	\N	Giấy Note 3x5 vàng	\N	100000.000	2026-06-03 16:51:47.162012	f	2026-06-03 16:51:47.162653	2026-06-03 16:51:47.162658	\N	f
184	456	note4mthe3-2-gi-y-note-4-m-u-th	Giấy Note 4 màu thẻ	\N	0.00	\N	\N	Giấy Note 4 màu thẻ	\N	100000.000	2026-06-03 16:51:47.164387	f	2026-06-03 16:51:47.16497	2026-06-03 16:51:47.164974	\N	f
185	457	note5m5l-note-5-m-u-5-l-p	NOTE 5 MÀU, 5 LỚP	\N	0.00	\N	\N	NOTE 5 MÀU, 5 LỚP	\N	100000.000	2026-06-03 16:51:47.166626	f	2026-06-03 16:51:47.167397	2026-06-03 16:51:47.167401	\N	f
186	458	notemt5m-note-m-i-t-n-5-m-u	Note mũi tên 5 màu	\N	0.00	\N	\N	Note mũi tên 5 màu	\N	100000.000	2026-06-03 16:51:47.169377	f	2026-06-03 16:51:47.169984	2026-06-03 16:51:47.169989	\N	f
187	459	paperonea380-gi-y-a380-paperone	Giấy A380 Paperone		0.00	\N	\N	Giấy A380 Paperone	\N	100000.000	2026-06-03 16:51:47.17171	f	2026-06-03 16:51:47.172285	2026-06-03 16:51:47.172289	\N	f
188	460	paperonea470-gi-y-paperone-a4-70	GIẤY PAPERONE -A4 70	\N	0.00	\N	\N	GIẤY PAPERONE -A4 70	\N	100000.000	2026-06-03 16:51:47.174242	f	2026-06-03 16:51:47.175125	2026-06-03 16:51:47.175129	\N	f
189	461	paperonea480-gi-y-paperone-a480	Giấy paperone A480	\N	0.00	\N	\N	Giấy paperone A480	\N	100000.000	2026-06-03 16:51:47.177078	f	2026-06-03 16:51:47.177682	2026-06-03 16:51:47.177686	\N	f
190	462	paperonealla4-gi-y-paperone-allpurpose-a4	Giấy Paperone Allpurpose  A4	\N	0.00	\N	\N	Giấy Paperone Allpurpose  A4	\N	100000.000	2026-06-03 16:51:47.179592	f	2026-06-03 16:51:47.180218	2026-06-03 16:51:47.180222	\N	f
191	463	paperonealla480-gi-y-tr-ng-paperone-all-purpose-80-gsm-a4	Giấy trắng Paperone All purpose 80 GSM A4	\N	0.00	\N	\N	Giấy trắng Paperone All purpose 80 GSM A4	\N	100000.000	2026-06-03 16:51:47.181939	f	2026-06-03 16:51:47.182622	2026-06-03 16:51:47.182626	\N	f
192	464	paperoneallpa4-gi-y-paperone-allpurpose-a4	Giấy Paperone Allpurpose A4	\N	0.00	\N	\N	Giấy Paperone Allpurpose A4	\N	100000.000	2026-06-03 16:51:47.184435	f	2026-06-03 16:51:47.185027	2026-06-03 16:51:47.185032	\N	f
193	465	paperonecopa3-gi-y-paperone-copier-a3	Giấy Paperone Copier A3		0.00	\N	\N	Giấy Paperone Copier A3	\N	100000.000	2026-06-03 16:51:47.186681	f	2026-06-03 16:51:47.187295	2026-06-03 16:51:47.1873	\N	f
194	466	paperonecopa4-gi-y-paperone-copier-a4	Giấy Paperone Copier A4	\N	0.00	\N	\N	Giấy Paperone Copier A4	\N	100000.000	2026-06-03 16:51:47.188998	f	2026-06-03 16:51:47.189587	2026-06-03 16:51:47.189591	\N	f
164	436	kepbuom19-k-p-b-m-diamon-white-19mm	Kẹp bướm Diamon White 19mm	None	3800.00	\N	/static/uploads/products/8e217e6d96c04d2fbe826c8fdb8a0424.jpg	Kẹp bướm Diamon White 19mm	\N	100000.000	2026-06-03 16:51:47.106084	f	2026-06-03 16:51:47.106758	2026-06-12 04:30:18.199335	\N	f
177	450	nhuayidua3-nh-a-p-yidu-a3	Nhựa ép YIDU A3		0.00	\N	\N	Nhựa ép YIDU A3	\N	100000.000	2026-06-03 16:51:47.144383	t	2026-06-03 16:51:47.145042	2026-07-16 12:44:51.5674	\N	f
178	449	nhuayidua4-nh-a-p-yidu-a4	Nhựa ép YiDU A4	None	0.00	\N	\N	Nhựa ép YiDU A4	\N	100000.000	2026-06-03 16:51:47.146904	t	2026-06-03 16:51:47.147515	2026-07-16 12:45:04.063318	\N	f
179	451	note3x2v-gi-y-note-3x2-v-ng	Giấy note 3x2 vàng	\N	0.00	\N	\N	Giấy note 3x2 vàng	\N	100000.000	2026-06-03 16:51:47.149519	t	2026-06-03 16:51:47.150127	2026-07-16 12:52:01.339503	\N	f
195	467	photocopya470-gi-y-photocopy-a4-70	Giấy photocopy A4 70	\N	0.00	\N	\N	Giấy photocopy A4 70	\N	100000.000	2026-06-03 16:51:47.191742	f	2026-06-03 16:51:47.192432	2026-06-03 16:51:47.192437	\N	f
196	468	photocopya480-gi-y-photocopy-a4-80	Giấy photocopy A4 80	\N	0.00	\N	\N	Giấy photocopy A4 80	\N	100000.000	2026-06-03 16:51:47.194351	f	2026-06-03 16:51:47.194962	2026-06-03 16:51:47.194966	\N	f
197	469	qualitya470-gi-y-tr-ng-quality-70gsm-a4	Giấy trắng (Quality) - 70gsm A4	\N	0.00	\N	\N	Giấy trắng (Quality) - 70gsm A4	\N	100000.000	2026-06-03 16:51:47.19666	f	2026-06-03 16:51:47.19729	2026-06-03 16:51:47.197294	\N	f
198	470	qualitya480-gi-y-tr-ng-quality-80gsm-a4	Giấy trắng (Quality) - 80gsm A4	\N	0.00	\N	\N	Giấy trắng (Quality) - 80gsm A4	\N	100000.000	2026-06-03 16:51:47.199597	f	2026-06-03 16:51:47.200266	2026-06-03 16:51:47.200271	\N	f
199	471	samsungprea470-gi-y-samsung-premium-70-a4	Giấy Samsung premium 70 A4	\N	0.00	\N	\N	Giấy Samsung premium 70 A4	\N	100000.000	2026-06-03 16:51:47.202036	f	2026-06-03 16:51:47.20263	2026-06-03 16:51:47.202634	\N	f
201	473	smartista470-gi-y-tr-ng-smartist-70gsm-a4	Giấy trắng ( Smartist ) - 70gsm - A4	\N	0.00	\N	\N	Giấy trắng ( Smartist ) - 70gsm - A4	\N	100000.000	2026-06-03 16:51:47.206534	f	2026-06-03 16:51:47.207108	2026-06-03 16:51:47.207117	\N	f
202	474	supremea470-gi-y-tr-ng-supreme-70gsm-a4	Giấy trắng (Supreme) 70gsm A4	\N	0.00	\N	\N	Giấy trắng (Supreme) 70gsm A4	\N	100000.000	2026-06-03 16:51:47.210369	f	2026-06-03 16:51:47.211164	2026-06-03 16:51:47.21117	\N	f
203	475	tap200thm6-t-p-200-thm	Tập 200 THM	\N	0.00	\N	\N	Tập 200 THM	\N	100000.000	2026-06-03 16:51:47.213127	f	2026-06-03 16:51:47.214157	2026-06-03 16:51:47.214162	\N	f
204	476	tap96thm4o-t-p-96-thm-4	Tập 96 THM (4 ô)	\N	0.00	\N	\N	Tập 96 THM (4 ô)	\N	100000.000	2026-06-03 16:51:47.216213	f	2026-06-03 16:51:47.216829	2026-06-03 16:51:47.216833	\N	f
205	477	tap96thm5o-t-p-96-thm-5	Tập 96 THM (5 ô)	\N	0.00	\N	\N	Tập 96 THM (5 ô)	\N	100000.000	2026-06-03 16:51:47.218688	f	2026-06-03 16:51:47.219294	2026-06-03 16:51:47.219298	\N	f
206	478	trang-gi-y-tr-ng	Giấy trắng	\N	0.00	\N	\N	Giấy trắng	\N	100000.000	2026-06-03 16:51:47.220995	f	2026-06-03 16:51:47.221401	2026-06-03 16:51:47.221405	\N	f
109	479	bialo400g-b-a-l-400g	Bìa lỗ 400G		27000.00	\N	\N	Bìa lỗ 400G	\N	100000.000	2026-06-03 16:51:46.951654	f	2026-06-03 16:51:46.952267	2026-06-12 04:30:04.855516	\N	f
200	472	smartista370-gi-y-tr-ng-smartist-70gsm-a3	Giấy trắng ( Smartist ) - 70gsm - A3		0.00	\N	\N	Giấy trắng ( Smartist ) - 70gsm - A3	\N	100000.000	2026-06-03 16:51:47.204312	t	2026-06-03 16:51:47.204885	2026-06-12 04:30:25.504628	\N	f
163	435	kepbuom15-k-p-b-m-diamon-white-15mm	Kẹp bướm Diamon White 15mm	None	3500.00	\N	/static/uploads/products/c15e9acd384f43c58a2f565b1e898cf1.png	Kẹp bướm Diamon White 15mm	\N	100000.000	2026-06-03 16:51:47.103172	t	2026-06-03 16:51:47.103749	2026-07-16 14:45:44.498318	4500.00	f
\.


--
-- TOC entry 3457 (class 0 OID 68106)
-- Dependencies: 227
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.products (id, code, barcode, name, name_en, unit_id, unit, category_id, category, purchase_price, sale_price, vat_rate, min_stock, max_stock, allow_negative, description, is_active, created_at, updated_at, retail_price) FROM stdin;
378	BIADOUBLEA20LAXD	\N	Bìa lá Double A 20 xanh dương	\N	\N	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.132753	2026-05-27 10:51:30.132768	\N
379	BIADOUBLEA40LAXD	\N	Bìa lá Double A 40 xanh dương	\N	\N	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.135464	2026-05-27 10:51:30.13547	\N
377	BAMKIMS10	None	Bấm kim số 10		4	Hộp	\N		0.00	3000.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.127321	2026-06-01 12:48:21.164876	\N
382	BIAMAUA470	\N	Bìa màu A4 70	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.142732	2026-05-27 10:51:30.142738	\N
383	BIAMAUA480	\N	Bìa màu A4 80	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.145271	2026-05-27 10:51:30.145282	\N
384	BIANUTA4	\N	Bìa nút A4	\N	\N	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.14856	2026-05-27 10:51:30.148568	\N
385	BIANUTA4D	\N	Bìa nút A4 dày	\N	\N	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.152635	2026-05-27 10:51:30.152645	\N
386	BIANUTF4	\N	Bìa nút F4	\N	\N	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.155475	2026-05-27 10:51:30.15548	\N
387	BIATRANGA4	\N	Giấy Bìa Trắng A4	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.157757	2026-05-27 10:51:30.157762	\N
381	BIADOUBLEA60LAXDCC	None	Bìa lá cao cấp Double A 60 xanh dương		1	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.140373	2026-05-29 15:05:28.028824	\N
391	BRISTOL	\N	Giấy Bristol	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.170296	2026-05-27 10:51:30.170301	\N
392	BUTBITL027	\N	Bút bi TL027	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.172733	2026-05-27 10:51:30.172739	\N
393	BUTBITL027H	\N	Bút bi TL027 (hộp)	\N	\N	Hộp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.174969	2026-05-27 10:51:30.174975	\N
394	BUTBITL08	\N	Bút bi TL08	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.177302	2026-05-27 10:51:30.177307	\N
395	BUTBITL105	\N	Bút bi TL-105	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.179478	2026-05-27 10:51:30.179483	\N
396	BUTDAHL03	\N	Bút dạ quang HL03	\N	\N	Hộp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.184633	2026-05-27 10:51:30.184641	\N
397	BUTLBANGWB-03	\N	Bút lông bảng WB-03	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.188001	2026-05-27 10:51:30.18801	\N
398	BUTLDAUPM04	\N	Bút lông dầu PM04 (10c/h)	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.190211	2026-05-27 10:51:30.190216	\N
399	BUTLDAUPM04H	\N	Bút lông dầu - PM04 (hộp)	\N	\N	Hộp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.192761	2026-05-27 10:51:30.192766	\N
400	BUTLDAUPM09	\N	Bút lông dầu PM09 (10c/h)	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.195052	2026-05-27 10:51:30.195057	\N
401	BUTLDAUPM09H	\N	Bút lông dầu PM09 (hộp)	\N	\N	Hộp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.198111	2026-05-27 10:51:30.198118	\N
402	BUTTLF0.03	\N	Bút TL F0.03	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.201695	2026-05-27 10:51:30.2017	\N
403	BUTXOACP02	\N	Bút xóa CP02	\N	\N	Cây	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.204035	2026-05-27 10:51:30.20404	\N
404	CARBONLESSIMP2	\N	Giấy Carbonless IMP K210/2 - 2L	\N	\N	Thùng	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.206636	2026-05-27 10:51:30.206641	\N
405	COUCHE	\N	Giấy Couche	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.208782	2026-05-27 10:51:30.208787	\N
406	COUCHEDL300	\N	Giấy Couche ĐL 300	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.211002	2026-05-27 10:51:30.211008	\N
407	COUCHEDL70	\N	Giấy Couche ĐL 70	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.213541	2026-05-27 10:51:30.213548	\N
419	EXCELA370	None	Giấy Excel 70 A3		18	Reams	10	GIẤY A3	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.248146	2026-05-28 15:55:11.750411	\N
423	GIAYA370	None	Giấy A3 70		18	Reams	10	GIẤY A3	0.00	0.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.258545	2026-05-28 15:55:28.212174	\N
411	DOUBLEAA470	\N	Giấy DoubleA A4 70	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.227254	2026-05-27 10:51:30.227259	\N
412	DOUBLEAA480	\N	Giấy DoubleA A4 80	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.229393	2026-05-27 10:51:30.229398	\N
413	DOUBLEAA570	\N	Giấy trắng (Double A) 70gsm - A5	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.233616	2026-05-27 10:51:30.233622	\N
414	DOUBLEA480	\N	Giấy A480 double A	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.236004	2026-05-27 10:51:30.236011	\N
415	DUPLEX	\N	Giấy Duplex	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.238274	2026-05-27 10:51:30.23828	\N
416	DUPLEX270	\N	Giấy Duplex 270	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.24044	2026-05-27 10:51:30.240446	\N
417	DUPLEX350	\N	Giấy Duplex 350	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.24275	2026-05-27 10:51:30.242756	\N
424	GIAYA380	None	Giấy A3 80		18	Reams	10	GIẤY A3	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.260672	2026-05-28 15:55:46.606433	\N
420	EXCELA470	\N	Giấy A470 excel	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.250422	2026-05-27 10:51:30.250428	\N
421	F0MAU70	\N	Giấy F0 màu 70	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.253269	2026-05-27 10:51:30.253277	\N
422	GMAU160	\N	Giấy màu 160	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.255563	2026-05-27 10:51:30.255569	\N
438	KEPBUOM32	None	Kẹp bướm Diamon White 32mm		4	Hộp	9	Kẹp Bướm	7300.00	8300.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.297079	2026-06-13 07:07:55.127285	8300.00
439	KEPBUOM41	None	Kẹp bướm Diamon White 41mm		4	Hộp	9	Kẹp Bướm	10500.00	11500.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.300949	2026-06-13 07:08:13.095464	11500.00
425	GOLDENSTARA470	\N	Giấy Golden Star 70 A4 (2550 RAM)	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.26394	2026-05-27 10:51:30.263945	\N
426	IDEAA470	\N	Giấy trắng Idea 70gsm, A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.266568	2026-05-27 10:51:30.266573	\N
427	IDEAA480	\N	Giấy A480 Idea	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.268767	2026-05-27 10:51:30.268773	\N
428	IKPLUSA470	\N	Giấy IK Plus A4 70	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.27085	2026-05-27 10:51:30.270855	\N
429	IKPLUSA480	\N	Giấy A480 IK Plus	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.273637	2026-05-27 10:51:30.273646	\N
430	IVORY	\N	Giấy ivory	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.275881	2026-05-27 10:51:30.275886	\N
431	IVORYDL270	\N	Giấy IVORY ĐL 270	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.278631	2026-05-27 10:51:30.278636	\N
432	IVORYDL300	\N	Giấy IVORY ĐL 300	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.281558	2026-05-27 10:51:30.281565	\N
433	IVORYDL350	\N	Giấy IVORY ĐL 350	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.284636	2026-05-27 10:51:30.284641	\N
434	IVORYDL400	\N	Giấy IVORY DL 400	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.28732	2026-05-27 10:51:30.287333	\N
440	KEPBUOM51	None	Kẹp bướm Diamon White 51mm		4	Hộp	9	Kẹp Bướm	17500.00	18500.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.304017	2026-06-13 07:08:28.588336	18500.00
442	KEPBUOMMAU19	None	Kẹp bướm Diamon White màu 19mm/40		4	Hộp	9	Kẹp Bướm	0.00	15500.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.309111	2026-05-28 16:06:08.639468	\N
437	KEPBUOM25	None	Kẹp bướm Diamon White 25mm		4	Hộp	9	Kẹp Bướm	4300.00	5300.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.294217	2026-06-13 07:07:39.269032	5300.00
418	DUPLEXA3300	None	Giấy A3 Duplex 300		7	Ký	10	GIẤY A3	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.245025	2026-05-28 15:52:52.508048	\N
380	BIADOUBLEA40LAXDCC	\N	Bìa lá cao cấp Double A 40 xanh dương	\N	\N	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.138185	2026-05-27 10:51:30.13819	\N
390	BIALO700G	None	Bìa lỗ 700G		19	Xấp	12	Bìa Lỗ	0.00	0.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.167095	2026-07-17 11:42:04.141748	0.00
410	DOUBLEAA380	None	Giấy A3 80 Double A		18	Reams	8	GIẤY Double A	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.22474	2026-07-20 08:23:48.180868	0.00
408	DOUBLEAA3	None	Giấy DoubleA A3 70		18	Reams	8	GIẤY Double A	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.218648	2026-07-20 08:23:03.85988	0.00
475	TAP200THM6	\N	Tập 200 THM	\N	\N	Cuốn	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.406443	2026-05-27 10:51:30.40645	\N
476	TAP96THM4O	\N	Tập 96 THM (4 ô)	\N	\N	Cuốn	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.409705	2026-05-27 10:51:30.409714	\N
477	TAP96THM5O	\N	Tập 96 THM (5 ô)	\N	\N	Cuốn	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.413085	2026-05-27 10:51:30.413094	\N
478	TRANG	\N	Giấy trắng	\N	\N	kg	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.416434	2026-05-27 10:51:30.416445	\N
458	NOTEMT5M	\N	Note mũi tên 5 màu	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.349105	2026-05-27 10:51:30.349118	\N
445	KEPBUOMMAU41	None	Kẹp bướm Diamon White màu 41mm/24		4	Hộp	9	Kẹp Bướm	0.00	30000.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.317243	2026-05-28 16:07:53.024108	\N
460	PAPERONEA470	\N	GIẤY PAPERONE -A4 70	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.353985	2026-05-27 10:51:30.35399	\N
461	PAPERONEA480	\N	Giấy paperone A480	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.35707	2026-05-27 10:51:30.357078	\N
462	PAPERONEALLA4	\N	Giấy Paperone Allpurpose  A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.360367	2026-05-27 10:51:30.360379	\N
463	PAPERONEALLA480	\N	Giấy trắng Paperone All purpose 80 GSM A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.363946	2026-05-27 10:51:30.363957	\N
464	PAPERONEALLPA4	\N	Giấy Paperone Allpurpose A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.367852	2026-05-27 10:51:30.367861	\N
446	KEPBUOMMAU51	None	Kẹp bướm Diamon White màu 51mm/12		4	Hộp	9	Kẹp Bướm	0.00	25000.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.320066	2026-05-28 16:08:24.746402	\N
466	PAPERONECOPA4	\N	Giấy Paperone Copier A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.374644	2026-05-27 10:51:30.374653	\N
467	PHOTOCOPYA470	\N	Giấy photocopy A4 70	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.378208	2026-05-27 10:51:30.378217	\N
468	PHOTOCOPYA480	\N	Giấy photocopy A4 80	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.382181	2026-05-27 10:51:30.382192	\N
469	QUALITYA470	\N	Giấy trắng (Quality) - 70gsm A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.386153	2026-05-27 10:51:30.386162	\N
470	QUALITYA480	\N	Giấy trắng (Quality) - 80gsm A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.389771	2026-05-27 10:51:30.389781	\N
471	SAMSUNGPREA470	\N	Giấy Samsung premium 70 A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.393652	2026-05-27 10:51:30.393664	\N
479	BIALO400G		Bìa lỗ 400G		19	Xấp	12	Bìa Lỗ	17000.00	27000.00	8.00	0.000	0.000	t		t	2026-05-28 13:49:16.877885	2026-07-02 11:08:55.297676	27000.00
473	SMARTISTA470	\N	Giấy trắng ( Smartist ) - 70gsm - A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.400384	2026-05-27 10:51:30.400397	\N
474	SUPREMEA470	\N	Giấy trắng (Supreme) 70gsm A4	\N	\N	Ram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.4034	2026-05-27 10:51:30.403406	\N
447	KIMBAMS10	\N	Kim bấm số 10	\N	\N	Hộp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.322416	2026-05-27 10:51:30.322421	\N
448	MAUA4	\N	Giấy màu A4	\N	\N	Gram	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.325274	2026-05-27 10:51:30.32528	\N
452	NOTE3x3SN	\N	Giấy Note 3x3 sọc ngang	\N	\N	Cái	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.334844	2026-05-27 10:51:30.334849	\N
453	NOTE3x3V	\N	Giấy note 3x3 vàng	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.336964	2026-05-27 10:51:30.336972	\N
454	NOTE3x4V	\N	Giấy note 3x4 vàng	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.339341	2026-05-27 10:51:30.339348	\N
455	NOTE3x5V	\N	Giấy Note 3x5 vàng	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.341661	2026-05-27 10:51:30.341666	\N
456	NOTE4MTHE3.2	\N	Giấy Note 4 màu thẻ	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.343821	2026-05-27 10:51:30.343828	\N
457	NOTE5M5L	\N	NOTE 5 MÀU, 5 LỚP	\N	\N	Xấp	\N		0.00	0.00	8.00	0.000	0.000	t	\N	t	2026-05-27 10:51:30.345986	2026-05-27 10:51:30.34599	\N
435	KEPBUOM15	None	Kẹp bướm Diamon White 15mm		4	Hộp	9	Kẹp Bướm	2500.00	3500.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.2894	2026-06-13 07:06:57.075755	5500.00
436	KEPBUOM19	None	Kẹp bướm Diamon White 19mm		4	Hộp	9	Kẹp Bướm	2800.00	3800.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.291544	2026-06-13 07:07:20.438996	5800.00
388	BIALO500G	None	Bìa lỗ 500G		19	Xấp	12	Bìa Lỗ	25000.00	35000.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.159993	2026-06-13 16:59:24.570987	35000.00
459	PAPERONEA380	None	Giấy A380 Paperone		18	Reams	10	GIẤY A3	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.351744	2026-05-28 15:56:39.487982	\N
465	PAPERONECOPA3	None	Giấy Paperone Copier A3		18	Reams	10	GIẤY A3	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.37136	2026-05-28 15:56:59.846995	\N
443	KEPBUOMMAU25	None	Kẹp bướm Diamon White màu 25mm/48		4	Hộp	9	Kẹp Bướm	0.00	25000.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.311292	2026-05-28 16:06:42.063093	\N
444	KEPBUOMMAU32	None	Kẹp bướm Diamon White màu 32mm/24		4	Hộp	9	Kẹp Bướm	0.00	21000.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.314837	2026-05-28 16:07:21.600831	\N
450	NHUAYIDUA3	None	Nhựa ép YIDU A3		19	Xấp	11	Ép Nhiệt	0.00	0.00	8.00	0.000	0.000	t		t	2026-05-27 10:51:30.330285	2026-07-16 12:43:48.392026	0.00
449	NHUAYIDUA4	None	Nhựa ép YiDU A4		19	Xấp	11	Ép Nhiệt	0.00	0.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.327991	2026-07-16 12:44:05.889197	0.00
389	BIALO600G	None	Bìa lỗ 600G		19	Xấp	12	Bìa Lỗ	0.00	0.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.162682	2026-07-17 11:41:45.917661	0.00
441	KEPBUOMMAU15	None	Kẹp bướm Diamon White màu 15mm/60		4	Hộp	9	Kẹp Bướm	0.00	16500.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.306819	2026-07-17 11:44:26.369538	16500.00
451	NOTE3x2V	None	Giấy note 3x2 vàng		19	Xấp	13	Note	0.00	0.00	8.00	0.000	0.000	t	None	t	2026-05-27 10:51:30.332724	2026-07-20 03:58:39.456095	18000.00
409	DOUBLEAA370	None	Giấy trắng (Double A) - 70gsm - A3		18	Reams	8	GIẤY Double A	0.00	0.00	8.00	0.000	0.000	t		f	2026-05-27 10:51:30.221987	2026-07-20 10:10:59.492703	0.00
472	SMARTISTA370	None	Giấy trắng ( Smartist ) - 70gsm - A3		18	Reams	10	GIẤY Smartist	0.00	0.00	8.00	0.000	0.000	t	Định lượng 70gsm	t	2026-05-27 10:51:30.396828	2026-07-20 12:16:36.362404	70000.00
\.


--
-- TOC entry 3498 (class 0 OID 99824)
-- Dependencies: 268
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.promotions (id, code, name, description, discount_type, discount_value, min_order_amount, starts_at, ends_at, is_active, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3488 (class 0 OID 91589)
-- Dependencies: 258
-- Data for Name: quotation_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.quotation_items (id, quotation_id, product_id, unit_id, conversion_factor, quantity, unit_price, vat_rate, vat_amount, amount, total_amount, note) FROM stdin;
37	1	435	\N	1.0000	100.000	3500.00	0.00	0.00	350000.00	350000.00	
38	1	436	\N	1.0000	100.000	3800.00	0.00	0.00	380000.00	380000.00	
39	1	437	\N	1.0000	100.000	5300.00	0.00	0.00	530000.00	530000.00	
40	1	438	\N	1.0000	100.000	8300.00	0.00	0.00	830000.00	830000.00	
41	1	439	\N	1.0000	100.000	11500.00	0.00	0.00	1150000.00	1150000.00	
42	1	440	\N	1.0000	100.000	18500.00	0.00	0.00	1850000.00	1850000.00	
\.


--
-- TOC entry 3486 (class 0 OID 91552)
-- Dependencies: 256
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.quotations (id, code, date, valid_until, customer_id, subtotal, discount_amount, vat_amount, total_amount, vat_mode, vat_rate_grouped, status, note, terms, stock_out_id, created_by, created_at, updated_at, recipient_name, recipient_address, recipient_phone, recipient_email) FROM stdin;
1	BG-20260529-001	2026-05-29	2026-06-05	275	5090000.00	0.00	0.00	5090000.00	grouped	0.00	converted		Giá có hiệu lực theo thời hạn báo giá.	16	1	2026-05-29 06:38:24.750757	2026-06-12 16:42:26.283502	CHI NHÁNH 1 CÔNG TY TNHH  TIN HỌC ANH VIỆT	Số 12-14 Nguyễn Trung Trực, Phường Long An, Tây Ninh, Việt Nam.		
\.


--
-- TOC entry 3500 (class 0 OID 99843)
-- Dependencies: 270
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.reviews (id, listing_id, product_id, customer_id, customer_name, rating, title, content, status, created_at) FROM stdin;
\.


--
-- TOC entry 3469 (class 0 OID 68254)
-- Dependencies: 239
-- Data for Name: stock_in_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_in_items (id, stock_in_id, product_id, quantity, unit_price, vat_rate, vat_amount, amount, total_amount, note, unit_id, conversion_factor) FROM stdin;
1	1	388	1000.000	25000.00	8.00	2000000.00	25000000.00	27000000.00	\N	\N	1.0000
\.


--
-- TOC entry 3459 (class 0 OID 68129)
-- Dependencies: 229
-- Data for Name: stock_ins; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_ins (id, code, date, supplier_id, warehouse_id, invoice_no, invoice_series, invoice_date, reference, subtotal, discount_pct, discount_amount, vat_amount, total_amount, paid_amount, vat_manual, vat_manual_val, status, note, created_by, confirmed_by, confirmed_at, created_at, updated_at, unit_id, conversion_factor) FROM stdin;
1	PN-260614-001	2026-06-14	17	2			\N	\N	25000000.00	0.00	0.00	2000000.00	27000000.00	0.00	f	0.00	confirmed		1	1	2026-06-13 17:45:58.131703	2026-06-13 17:25:05.325673	2026-06-13 17:45:58.136302	\N	1.0000
\.


--
-- TOC entry 3471 (class 0 OID 68272)
-- Dependencies: 241
-- Data for Name: stock_out_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_out_items (id, stock_out_id, product_id, quantity, unit_price, cost_price, vat_rate, vat_amount, amount, total_amount, note, unit_id, conversion_factor, box_note) FROM stdin;
17	15	472	10.000	70000.00	0.00	0.00	0.00	700000.00	700000.00	\N	18	1.0000	\N
18	16	435	100.000	3500.00	0.00	0.00	0.00	350000.00	350000.00	\N	\N	1.0000	\N
19	16	436	100.000	3800.00	0.00	0.00	0.00	380000.00	380000.00	\N	\N	1.0000	\N
20	16	437	100.000	5300.00	0.00	0.00	0.00	530000.00	530000.00	\N	\N	1.0000	\N
21	16	438	100.000	8300.00	0.00	0.00	0.00	830000.00	830000.00	\N	\N	1.0000	\N
22	16	439	100.000	11500.00	0.00	0.00	0.00	1150000.00	1150000.00	\N	\N	1.0000	\N
23	16	440	100.000	18500.00	0.00	0.00	0.00	1850000.00	1850000.00	\N	\N	1.0000	\N
25	17	388	20.000	35000.00	0.00	0.00	0.00	700000.00	700000.00	\N	19	1.0000	0.4
26	18	388	100.000	35000.00	0.00	0.00	0.00	3500000.00	3500000.00	\N	\N	1.0000	2
27	19	388	50.000	35000.00	247.82	0.00	0.00	1750000.00	1750000.00	\N	\N	1.0000	1
28	20	388	70.000	35000.00	247.82	0.00	0.00	2450000.00	2450000.00	\N	\N	1.0000	1
29	21	479	100.000	27000.00	0.00	0.00	0.00	2700000.00	2700000.00	\N	\N	1.0000	2
30	22	388	5.000	35000.00	247.82	0.00	0.00	175000.00	175000.00	\N	19	1.0000	\N
31	23	388	1.000	35000.00	247.82	0.00	0.00	35000.00	35000.00	\N	19	1.0000	\N
32	24	388	5.000	35000.00	247.82	0.00	0.00	175000.00	175000.00	\N	19	1.0000	\N
33	25	388	5.000	35000.00	247.82	0.00	0.00	175000.00	175000.00	\N	19	1.0000	\N
34	26	388	1.000	35000.00	247.82	0.00	0.00	35000.00	35000.00	\N	19	1.0000	\N
\.


--
-- TOC entry 3461 (class 0 OID 68162)
-- Dependencies: 231
-- Data for Name: stock_outs; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_outs (id, code, date, customer_id, warehouse_id, invoice_no, invoice_series, reference, subtotal, discount_pct, discount_amount, vat_amount, total_amount, paid_amount, vat_manual, vat_manual_val, status, note, created_by, confirmed_by, confirmed_at, created_at, updated_at, unit_id, conversion_factor, vat_mode, vat_rate_grouped) FROM stdin;
26	PX-260716-005	2026-07-16	298	2	\N	\N	WEB-260716-0012	35000.00	0.00	0.00	0.00	35000.00	0.00	f	0.00	confirmed	Sync từ đơn online WEB-260716-0012.	1	1	2026-07-16 10:32:19.820808	2026-07-16 10:32:19.793908	2026-07-16 10:32:19.825804	\N	1.0000	grouped	0.00
15	PX-WEB-260612-0001	2026-06-12	\N	2	\N	\N	WEB-260612-0001	700000.00	0.00	0.00	0.00	700000.00	0.00	f	0.00	confirmed	Sync từ đơn online WEB-260612-0001.	1	1	2026-06-12 16:39:38.586788	2026-06-12 16:38:57.638826	2026-06-12 16:39:38.599513	\N	1.0000	grouped	0.00
16	PX-260612-001	2026-06-12	275	2	\N	\N	\N	5090000.00	0.00	0.00	0.00	5090000.00	0.00	f	0.00	confirmed	Chuyển từ báo giá BG-20260529-001.	1	1	2026-06-12 16:43:24.328571	2026-06-12 16:42:26.245228	2026-06-12 16:43:24.391754	\N	1.0000	grouped	0.00
17	PX-WEB-260613-0001	2026-06-13	\N	2	None	None	WEB-260613-0001	700000.00	0.00	0.00	0.00	700000.00	0.00	f	0.00	confirmed	Sync từ đơn online WEB-260613-0001.	1	1	2026-06-13 06:08:28.44442	2026-06-12 17:04:57.881281	2026-06-13 06:08:28.48561	\N	1.0000	grouped	0.00
18	PX-260614-001	2026-06-13	255	2			\N	3500000.00	0.00	0.00	0.00	3500000.00	0.00	f	0.00	confirmed		1	1	2026-06-13 17:01:05.838399	2026-06-13 17:00:58.523214	2026-06-13 17:01:05.883657	\N	1.0000	grouped	0.00
19	PX-260614-002	2026-06-14	272	2			\N	1750000.00	0.00	0.00	0.00	1750000.00	0.00	f	0.00	confirmed		1	1	2026-06-13 17:48:10.241593	2026-06-13 17:48:06.092025	2026-06-13 17:48:10.243433	\N	1.0000	grouped	0.00
20	PX-260616-001	2026-06-16	275	2			\N	2450000.00	0.00	0.00	0.00	2450000.00	0.00	f	0.00	confirmed		1	1	2026-06-16 04:10:52.148997	2026-06-16 04:10:45.635783	2026-06-16 04:10:52.173516	\N	1.0000	grouped	0.00
21	PX-260702-001	2026-07-02	255	2			\N	2700000.00	0.00	0.00	0.00	2700000.00	0.00	f	0.00	confirmed		1	1	2026-07-02 11:09:52.308582	2026-07-02 11:09:47.380048	2026-07-02 11:09:52.363333	\N	1.0000	grouped	0.00
22	PX-260716-001	2026-07-16	\N	2	\N	\N	WEB-260716-0004	175000.00	0.00	0.00	0.00	175000.00	0.00	f	0.00	confirmed	Sync từ đơn online WEB-260716-0004.	1	1	2026-07-16 10:05:26.677051	2026-07-16 10:05:26.492697	2026-07-16 10:05:26.707755	\N	1.0000	grouped	0.00
23	PX-260716-002	2026-07-16	\N	2	\N	\N	WEB-260716-0003	35000.00	0.00	0.00	0.00	35000.00	0.00	f	0.00	confirmed	Sync từ đơn online WEB-260716-0003.	1	1	2026-07-16 10:05:35.247081	2026-07-16 10:05:35.228956	2026-07-16 10:05:35.250666	\N	1.0000	grouped	0.00
24	PX-260716-003	2026-07-16	\N	2	\N	\N	WEB-260716-0002	175000.00	0.00	0.00	0.00	175000.00	0.00	f	0.00	confirmed	Sync từ đơn online WEB-260716-0002.	1	1	2026-07-16 10:05:38.5693	2026-07-16 10:05:38.555402	2026-07-16 10:05:38.572307	\N	1.0000	grouped	0.00
25	PX-260716-004	2026-07-16	\N	2	\N	\N	WEB-260716-0001	175000.00	0.00	0.00	0.00	175000.00	0.00	f	0.00	confirmed	Sync từ đơn online WEB-260716-0001.	1	1	2026-07-16 10:05:42.41014	2026-07-16 10:05:42.374721	2026-07-16 10:05:42.416569	\N	1.0000	grouped	0.00
\.


--
-- TOC entry 3512 (class 0 OID 111823)
-- Dependencies: 282
-- Data for Name: stocktaking_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stocktaking_items (id, stocktaking_id, product_id, book_quantity, actual_quantity, difference, note, is_adjusted) FROM stdin;
\.


--
-- TOC entry 3510 (class 0 OID 111792)
-- Dependencies: 280
-- Data for Name: stocktakings; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stocktakings (id, warehouse_id, count_date, status, note, created_by, completed_by, completed_at, cancelled_by, cancelled_at, created_at) FROM stdin;
\.


--
-- TOC entry 3445 (class 0 OID 68027)
-- Dependencies: 215
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.suppliers (id, code, name, short_name, address, phone, fax, email, website, tax_code, contact_person, bank_account, bank_name, bank_branch, payment_terms, credit_limit, note, is_active, created_at) FROM stdin;
6	301424549	CÔNG TY TNHH SẢN XUẤT THƯƠNG MẠI KIM HOÀN VŨ	\N	100 Đường A4, Phường 12, Quận Tân Bình, Thành phố Hồ Chí Minh, Việt Nam		\N		\N	301424549	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.195749
7	306012059	CÔNG TY TNHH THƯƠNG MẠI DỊCH VỤ SẢN XUẤT GIẤY KHẢI HOÀN	\N	105/27/3 Đường số 59, Phường An Hội Tây, TP Hồ Chí Minh, Việt Nam.		\N		\N	306012059	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.198828
8	312013251	CÔNG TY TNHH MỘT THÀNH VIÊN HUY MINH QUANG	\N	506/10 Đường 3/2, Phường 14, Quận 10, Thành phố Hồ Chí Minh, Việt Nam		\N		\N	312013251	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.201309
9	312437941	CÔNG TY TNHH MỘT THÀNH VIÊN ĐỨC HÂN PHÁT	\N	9/7 Nguyễn Quý Yêm, Khu phố 4, Phường An Lạc, TP Hồ Chí Minh, Việt Nam.		\N		\N	312437941	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.203589
10	314033140	CÔNG TY TNHH ĐẦU TƯ THƯƠNG MẠI DỊCH VỤ NHÂN DŨNG	\N	Số 97/10 Đường Trần Bá Giao, Phường An Nhơn, TP Hồ Chí Minh, Việt Nam.		\N		\N	314033140	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.205453
11	317859390	CÔNG TY TNHH THƯƠNG MẠI XNK GIA THÀNH	\N	127 Đặng Thuỳ Trâm, Phường Bình Lợi Trung, TP Hồ Chí Minh, Việt Nam.		\N		\N	317859390	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.207405
12	319015466	CÔNG TY TNHH MTV SX TM DV QUANG THỊNH	\N	GF-29B Tầng trệt Crescent Mall, 101 Tôn Dật Tiên, Phường Tân Phú(Hết hiệu lực), TP Hồ Chí Minh, Việt Nam.		\N		\N	319015466	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.209368
13	319025947	CÔNG TY TNHH MTV SX TM DV THÀNH HUY	\N	Tầng 2 Tòa nhà Hà Phan, Số 1119 Trần Hưng Đạo, Phường Bàn Cờ, TP Hồ Chí Minh, Việt Nam.		\N		\N	319025947	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.211523
14	319156918	CÔNG TY TNHH THƯƠNG MẠI DỊCH VỤ THẠCH KHUÊ	\N	84 Tân Kỳ Tân Quý, Phường Tây Thạnh, TP Hồ Chí Minh, Việt Nam.		\N		\N	319156918	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.213438
15	319260901	CÔNG TY TNHH MTV SX TM DV THÀNH LỘC	\N	Phòng 1010 Lầu 10 Tòa nhà Diamond Plaza, 34 Lê Duẩn, Phường Sài Gòn, TP Hồ Chí Minh, Việt Nam.		\N		\N	319260901	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.21526
16	3703312216	CÔNG TY TNHH TM DV HUY CƯỜNG VINA	\N	Số 301/12, Khu phố Tân Ba, Phường Tân Đông Hiệp, TP Hồ Chí Minh, Việt Nam.		\N		\N	3703312216	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.217253
17	3703354209	CÔNG TY TNHH BÁCH HOÁ TỔNG HỢP TRẦN SANG	\N	Số 26 Đường Tô Hoài, Phường Tân Hiệp, TP Hồ Chí Minh		\N		\N	3703354209	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.219481
18	3703356164	CÔNG TY TNHH TMDV PHƯỚC HẬU	\N	Số 66 Khu phố Tân Hội, Phường Tân Hiệp, Thành phố Hồ Chí Minh, Việt Nam.		\N		\N	3703356164	\N	\N	\N	\N	30	0.00	\N	t	2026-05-14 15:42:22.221093
\.


--
-- TOC entry 3439 (class 0 OID 67989)
-- Dependencies: 209
-- Data for Name: system_configs; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.system_configs (id, key, value, description, group_name, updated_at) FROM stdin;
9	payment_terms_default	30	Thời hạn TT mặc định (ngày)	accounting	2026-03-17 06:49:16.216885
11	fiscal_year_start	01-01	Bắt đầu năm tài chính (MM-DD)	accounting	2026-03-17 06:49:16.222167
12	low_stock_alert	true	Cảnh báo hàng sắp hết	inventory	2026-03-17 06:49:16.224821
13	auto_create_debt	true	Tự động tạo công nợ khi xác nhận phiếu	accounting	2026-03-17 06:49:16.226864
14	auto_create_vat	true	Tự động tạo bản ghi VAT	accounting	2026-03-17 06:49:16.229061
4	company_fax		Số fax	company	2026-03-17 13:44:11.873256
5	company_email	cg3090@gmail.com	Email	company	2026-03-17 13:44:11.877372
16	company_bank_account		Số tài khoản	company	2026-03-17 13:44:11.887501
17	company_bank_name		Tên ngân hàng	company	2026-03-17 13:44:11.891268
18	company_bank_branch		Chi nhánh NH	company	2026-03-17 13:44:11.894568
20	company_accountant		Kế toán trưởng	company	2026-03-17 13:44:11.90073
21	allow_negative_stock	true	Cho phép xuất âm kho	inventory	2026-03-17 13:44:11.907811
1	company_name	Công ty TNHH Công Nghệ Việt	Tên công ty	company	2026-03-21 09:48:31.890268
15	company_name_en	Viet Informatics	Tên tiếng Anh	company	2026-03-21 09:48:31.909135
2	company_address	TP.HCM	Địa chỉ công ty	company	2026-03-21 09:48:31.911271
3	company_phone	0903 671 304	Số điện thoại	company	2026-03-21 09:48:31.912502
10	currency	VND	Đơn vị tiền tệ	accounting	2026-03-21 09:48:31.931488
22	invoice_prefix_in	PN	Tiền tố số phiếu nhập	system	2026-03-21 17:36:43.583757
23	invoice_prefix_out	PX	Tiền tố số phiếu xuất	system	2026-03-21 17:36:43.586304
24	sys_status_normalized_v1	1	startup maintenance flag	system	2026-04-02 23:08:00.738371
25	sys_unit_conv_menu_seeded_v1	1	startup maintenance flag	system	2026-04-02 23:08:01.221584
7	company_website	localhost:5000	Website	company	2026-04-02 16:43:37.586137
26	acc_cash	111	Tiền mặt	accounting	2026-04-09 03:36:05.076554
27	acc_bank	112	Tiền gửi không kỳ hạn	accounting	2026-04-09 03:36:05.097124
28	acc_ar	131	Phải thu của khách hàng	accounting	2026-04-09 03:36:05.099342
29	acc_ap	331	Phải trả cho người bán	accounting	2026-04-09 03:36:05.101482
31	acc_vat_in	1331	Thuế GTGT được khấu trừ của hàng hóa, dịch vụ	accounting	2026-04-09 03:36:05.106918
32	acc_vat_out	3331	Thuế giá trị gia tăng phải nộp	accounting	2026-04-09 03:36:05.109225
33	acc_revenue	511	Doanh thu bán hàng và cung cấp dịch vụ	accounting	2026-04-09 03:36:05.111284
34	acc_cogs	632	Giá vốn hàng bán	accounting	2026-04-09 03:36:05.113282
30	acc_inventory	1561	Hàng hóa	accounting	2026-05-20 05:05:48.496187
19	company_director	Trần Quốc Việt	Giám đốc	company	2026-06-12 09:41:08.753217
6	company_tax_code	03123456789	Mã số thuế	company	2026-06-12 09:42:10.584503
8	default_vat_rate	0	Thuế suất VAT mặc định (%)	accounting	2026-06-12 09:42:10.597337
\.


--
-- TOC entry 3480 (class 0 OID 69982)
-- Dependencies: 250
-- Data for Name: unit_conversions; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.unit_conversions (id, product_id, from_unit_id, to_unit_id, conversion_factor) FROM stdin;
18	445	6	4	60.0000
19	446	6	4	60.0000
43	440	6	4	60.0000
44	388	6	19	50.0000
15	442	6	4	50.0000
16	443	6	4	50.0000
17	444	6	4	50.0000
48	435	6	4	360.0000
50	436	6	4	300.0000
51	437	6	4	240.0000
52	438	6	4	120.0000
53	439	6	4	120.0000
54	441	6	4	50.0000
55	479	6	19	50.0000
\.


--
-- TOC entry 3441 (class 0 OID 68002)
-- Dependencies: 211
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.units (id, code, name, description, is_active, created_at) FROM stdin;
1	CAI	Cái	\N	t	2026-03-17 06:49:16.368254
2	CHIEC	Chiếc	\N	t	2026-03-17 06:49:16.371726
3	BO	Bộ	\N	t	2026-03-17 06:49:16.373658
4	HOP	Hộp	\N	t	2026-03-17 06:49:16.374905
5	GOI	Gói	\N	t	2026-03-17 06:49:16.376392
6	THUNG	Thùng	\N	t	2026-03-17 06:49:16.379131
8	GRAM	Gram	\N	t	2026-03-17 06:49:16.383661
9	LIT	Lít	\N	t	2026-03-17 06:49:16.385679
10	MET	Mét	\N	t	2026-03-17 06:49:16.387824
11	M2	Mét vuông	\N	t	2026-03-17 06:49:16.389936
12	CUON	Cuộn	\N	t	2026-03-17 06:49:16.391427
13	CHAI	Chai	\N	t	2026-03-17 06:49:16.393382
14	LON	Lon	\N	t	2026-03-17 06:49:16.394763
15	BICH	Bịch	\N	t	2026-03-17 06:49:16.396863
16	TO	Tờ	\N	t	2026-03-17 06:49:16.3984
17	LOC	Lốc	\N	t	2026-03-17 06:49:16.368254
7	KG	Ký	\N	t	2026-03-17 06:49:16.381549
19	XAP	Xấp		t	2026-05-05 04:14:04.44484
18	RAM	Reams		t	2026-04-23 04:40:31.357254
\.


--
-- TOC entry 3484 (class 0 OID 91522)
-- Dependencies: 254
-- Data for Name: user_menu_overrides; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.user_menu_overrides (user_id, menu_id, is_visible) FROM stdin;
3	13	f
3	22	f
3	15	f
3	17	f
3	18	f
\.


--
-- TOC entry 3482 (class 0 OID 70020)
-- Dependencies: 252
-- Data for Name: user_permissions; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.user_permissions (id, user_id, module, can_view, can_add, can_edit, can_delete) FROM stdin;
89	1	dashboard	t	t	t	t
90	1	products	t	t	t	t
91	1	suppliers	t	t	t	t
92	1	customers	t	t	t	t
93	1	stock_in	t	t	t	t
94	1	stock_out	t	t	t	t
95	1	inventory	t	t	t	t
96	1	debt	t	t	t	t
97	1	accounting	t	t	t	t
98	1	reports	t	t	t	t
99	1	settings	t	t	t	t
168	3	dashboard	f	f	f	f
169	3	products	t	t	t	t
170	3	suppliers	t	t	t	t
171	3	customers	t	t	t	t
172	3	stock_in	t	t	t	t
173	3	stock_out	t	t	t	t
174	3	quotations	t	t	t	t
175	3	ecommerce	f	f	f	f
176	3	inventory	t	t	t	t
177	3	debt	t	t	t	t
178	3	accounting	f	f	f	f
179	3	reports	t	t	t	t
180	3	settings	f	f	f	f
181	3	opening_stock	f	f	f	f
45	2	dashboard	f	f	f	f
46	2	products	f	f	f	f
47	2	suppliers	f	f	f	f
48	2	customers	f	f	f	f
49	2	stock_in	f	f	f	f
50	2	stock_out	f	f	f	f
51	2	inventory	f	f	f	f
52	2	debt	f	f	f	f
53	2	accounting	f	f	f	f
54	2	reports	f	f	f	f
55	2	settings	f	f	f	f
\.


--
-- TOC entry 3437 (class 0 OID 67974)
-- Dependencies: 207
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.users (id, username, email, password_hash, full_name, role, is_active, last_login, created_at) FROM stdin;
4	user	user@erpviet.com	scrypt:32768:8:1$qiGHIFwgJHybNGGF$e9b1c0d2ec396786cd377356934231728498103bce24281206757d4a1bae877e3a2c84ce2abd7ec74a86dca065353d661bdb09c8cee01f52dd833628dc68c517	User	user	t	2026-03-24 15:46:21.082674	2026-03-18 06:23:15.031895
2	ketoan	ketoan@erpviet.com	scrypt:32768:8:1$oA2AzIvzKrqtpxUa$ea45a35b2bc2599e5961bdd78c432c54cb85d30492d56967ceb591fe12263ed2fd1f3431a8c5d6621fb3b0458854bb5769ca17247f4de9f6063f4027de49e839	Kế toán viên	accountant	t	2026-04-09 11:07:33.238391	2026-03-17 06:49:16.725414
3	kho	kho@erpviet.com	scrypt:32768:8:1$MWwPlZnjm7bqgN0C$1f77f1009176f6c281f3e8066b45bc1fa63af42017ee241dc423145f98e1ce3e41a2f99f578263a7a2df25703a1a313527eeb7748a1a7179d538fcc652a6afa7	Thủ Kho	warehouse	t	2026-07-21 15:28:39.957032	2026-03-17 17:03:57.089286
1	admin	cg3090@gmail.com	scrypt:32768:8:1$FvYSaNZTt63DWn0U$8fa90e64257e86b7aadbce828931666f8952fe250579e5da4a21fbded0523468c300b7ecd552bb8d70b705e48809aba336e7d138a11695400a4d734f9fe493cc	Quản trị viên	admin	t	2026-07-22 03:59:15.953529	2026-03-17 06:49:16.725409
\.


--
-- TOC entry 3455 (class 0 OID 68095)
-- Dependencies: 225
-- Data for Name: vat_records; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.vat_records (id, vat_type, date, invoice_no, invoice_series, reference_type, reference_id, reference_code, partner_name, partner_tax_code, partner_address, taxable_amount, vat_rate, vat_amount, total_amount, is_deductible, period_month, period_year, note, created_at) FROM stdin;
1	input	2026-06-14		\N	stock_in	1	PN-260614-001	CÔNG TY TNHH BÁCH HOÁ TỔNG HỢP TRẦN SANG	3703354209	Số 26 Đường Tô Hoài, Phường Tân Hiệp, TP Hồ Chí Minh	25000000.00	8.00	2000000.00	27000000.00	t	6	2026	\N	2026-06-13 17:45:58.140118
\.


--
-- TOC entry 3449 (class 0 OID 68053)
-- Dependencies: 219
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.warehouses (id, code, name, address, manager, phone, is_active, created_at) FROM stdin;
2	KHO_HCM	Kho TP.HCM	TP.HCM	Trần Văn A	028-9876-5432	t	2026-03-17 06:49:16.734986
\.


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 220
-- Name: account_charts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.account_charts_id_seq', 107, true);


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 263
-- Name: cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.cart_id_seq', 240, true);


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 265
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 65, true);


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 212
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.categories_id_seq', 13, true);


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 275
-- Name: customer_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.customer_accounts_id_seq', 20, true);


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 261
-- Name: customer_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.customer_sessions_id_seq', 226, true);


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 216
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.customers_id_seq', 299, true);


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 234
-- Name: debt_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.debt_payments_id_seq', 6, true);


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 222
-- Name: debts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.debts_id_seq', 6, true);


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 284
-- Name: erp_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.erp_users_id_seq', 1, false);


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 244
-- Name: inventory_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.inventory_history_id_seq', 131, true);


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 242
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.inventory_id_seq', 103, true);


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 232
-- Name: journal_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.journal_entries_id_seq', 14, true);


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 246
-- Name: journal_lines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.journal_lines_id_seq', 33, true);


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 202
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.menus_id_seq', 56, true);


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 204
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.notifications_id_seq', 14, true);


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 273
-- Name: online_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.online_order_items_id_seq', 38, true);


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 271
-- Name: online_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.online_orders_id_seq', 37, true);


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 236
-- Name: opening_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.opening_stocks_id_seq', 103, true);


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 277
-- Name: product_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.product_images_id_seq', 24, true);


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 259
-- Name: product_listings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.product_listings_id_seq', 206, true);


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 226
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.products_id_seq', 479, true);


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 267
-- Name: promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.promotions_id_seq', 1, false);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 257
-- Name: quotation_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.quotation_items_id_seq', 42, true);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 255
-- Name: quotations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.quotations_id_seq', 1, true);


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 269
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 238
-- Name: stock_in_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_in_items_id_seq', 1, true);


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 228
-- Name: stock_ins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_ins_id_seq', 1, true);


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 240
-- Name: stock_out_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_out_items_id_seq', 34, true);


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 230
-- Name: stock_outs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_outs_id_seq', 26, true);


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 281
-- Name: stocktaking_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stocktaking_items_id_seq', 1, false);


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 279
-- Name: stocktakings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stocktakings_id_seq', 1, false);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 214
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 18, true);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 208
-- Name: system_configs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.system_configs_id_seq', 34, true);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 249
-- Name: unit_conversions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.unit_conversions_id_seq', 55, true);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 210
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.units_id_seq', 19, true);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 251
-- Name: user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.user_permissions_id_seq', 181, true);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 206
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 224
-- Name: vat_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.vat_records_id_seq', 1, true);


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 218
-- Name: warehouses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.warehouses_id_seq', 3, true);


--
-- TOC entry 3104 (class 2606 OID 68076)
-- Name: account_charts account_charts_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts
    ADD CONSTRAINT account_charts_code_key UNIQUE (code);


--
-- TOC entry 3106 (class 2606 OID 68074)
-- Name: account_charts account_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts
    ADD CONSTRAINT account_charts_pkey PRIMARY KEY (id);


--
-- TOC entry 3223 (class 2606 OID 111849)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 3195 (class 2606 OID 99806)
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3192 (class 2606 OID 99784)
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- TOC entry 3088 (class 2606 OID 68019)
-- Name: categories categories_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_code_key UNIQUE (code);


--
-- TOC entry 3090 (class 2606 OID 68017)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3212 (class 2606 OID 99955)
-- Name: customer_accounts customer_accounts_email_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_accounts
    ADD CONSTRAINT customer_accounts_email_key UNIQUE (email);


--
-- TOC entry 3214 (class 2606 OID 99953)
-- Name: customer_accounts customer_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_accounts
    ADD CONSTRAINT customer_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 3188 (class 2606 OID 99766)
-- Name: customer_sessions customer_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_sessions
    ADD CONSTRAINT customer_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3190 (class 2606 OID 99768)
-- Name: customer_sessions customer_sessions_session_key_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_sessions
    ADD CONSTRAINT customer_sessions_session_key_key UNIQUE (session_key);


--
-- TOC entry 3096 (class 2606 OID 68050)
-- Name: customers customers_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_code_key UNIQUE (code);


--
-- TOC entry 3098 (class 2606 OID 68048)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 3141 (class 2606 OID 68218)
-- Name: debt_payments debt_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_pkey PRIMARY KEY (id);


--
-- TOC entry 3108 (class 2606 OID 68092)
-- Name: debts debts_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debts
    ADD CONSTRAINT debts_pkey PRIMARY KEY (id);


--
-- TOC entry 3225 (class 2606 OID 111864)
-- Name: erp_users erp_users_email_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.erp_users
    ADD CONSTRAINT erp_users_email_key UNIQUE (email);


--
-- TOC entry 3227 (class 2606 OID 111862)
-- Name: erp_users erp_users_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.erp_users
    ADD CONSTRAINT erp_users_pkey PRIMARY KEY (id);


--
-- TOC entry 3229 (class 2606 OID 111866)
-- Name: erp_users erp_users_username_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.erp_users
    ADD CONSTRAINT erp_users_username_key UNIQUE (username);


--
-- TOC entry 3153 (class 2606 OID 68315)
-- Name: inventory_history inventory_history_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_pkey PRIMARY KEY (id);


--
-- TOC entry 3149 (class 2606 OID 68295)
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- TOC entry 3137 (class 2606 OID 68205)
-- Name: journal_entries journal_entries_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_code_key UNIQUE (code);


--
-- TOC entry 3139 (class 2606 OID 68203)
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 3157 (class 2606 OID 68338)
-- Name: journal_lines journal_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines
    ADD CONSTRAINT journal_lines_pkey PRIMARY KEY (id);


--
-- TOC entry 3159 (class 2606 OID 68376)
-- Name: menu_roles menu_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menu_roles
    ADD CONSTRAINT menu_roles_pkey PRIMARY KEY (menu_id, role);


--
-- TOC entry 3066 (class 2606 OID 67953)
-- Name: menus menus_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_code_key UNIQUE (code);


--
-- TOC entry 3068 (class 2606 OID 67951)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- TOC entry 3070 (class 2606 OID 67971)
-- Name: notifications notifications_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_code_key UNIQUE (code);


--
-- TOC entry 3072 (class 2606 OID 67969)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3210 (class 2606 OID 99921)
-- Name: online_order_items online_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_order_items
    ADD CONSTRAINT online_order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3206 (class 2606 OID 99891)
-- Name: online_orders online_orders_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders
    ADD CONSTRAINT online_orders_code_key UNIQUE (code);


--
-- TOC entry 3208 (class 2606 OID 99889)
-- Name: online_orders online_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders
    ADD CONSTRAINT online_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3143 (class 2606 OID 68236)
-- Name: opening_stocks opening_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_pkey PRIMARY KEY (id);


--
-- TOC entry 3217 (class 2606 OID 102062)
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- TOC entry 3182 (class 2606 OID 99744)
-- Name: product_listings product_listings_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.product_listings
    ADD CONSTRAINT product_listings_pkey PRIMARY KEY (id);


--
-- TOC entry 3184 (class 2606 OID 99746)
-- Name: product_listings product_listings_product_id_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.product_listings
    ADD CONSTRAINT product_listings_product_id_key UNIQUE (product_id);


--
-- TOC entry 3186 (class 2606 OID 99748)
-- Name: product_listings product_listings_slug_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.product_listings
    ADD CONSTRAINT product_listings_slug_key UNIQUE (slug);


--
-- TOC entry 3116 (class 2606 OID 68116)
-- Name: products products_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_code_key UNIQUE (code);


--
-- TOC entry 3118 (class 2606 OID 68114)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3197 (class 2606 OID 99840)
-- Name: promotions promotions_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_code_key UNIQUE (code);


--
-- TOC entry 3199 (class 2606 OID 99838)
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- TOC entry 3179 (class 2606 OID 91599)
-- Name: quotation_items quotation_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3175 (class 2606 OID 91571)
-- Name: quotations quotations_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_code_key UNIQUE (code);


--
-- TOC entry 3177 (class 2606 OID 91569)
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (id);


--
-- TOC entry 3201 (class 2606 OID 99854)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 3145 (class 2606 OID 68259)
-- Name: stock_in_items stock_in_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT stock_in_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3124 (class 2606 OID 68139)
-- Name: stock_ins stock_ins_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_code_key UNIQUE (code);


--
-- TOC entry 3126 (class 2606 OID 68137)
-- Name: stock_ins stock_ins_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_pkey PRIMARY KEY (id);


--
-- TOC entry 3147 (class 2606 OID 68277)
-- Name: stock_out_items stock_out_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT stock_out_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3131 (class 2606 OID 68172)
-- Name: stock_outs stock_outs_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_code_key UNIQUE (code);


--
-- TOC entry 3133 (class 2606 OID 68170)
-- Name: stock_outs stock_outs_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_pkey PRIMARY KEY (id);


--
-- TOC entry 3221 (class 2606 OID 111828)
-- Name: stocktaking_items stocktaking_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktaking_items
    ADD CONSTRAINT stocktaking_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3219 (class 2606 OID 111800)
-- Name: stocktakings stocktakings_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktakings
    ADD CONSTRAINT stocktakings_pkey PRIMARY KEY (id);


--
-- TOC entry 3092 (class 2606 OID 68037)
-- Name: suppliers suppliers_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_code_key UNIQUE (code);


--
-- TOC entry 3094 (class 2606 OID 68035)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- TOC entry 3080 (class 2606 OID 67999)
-- Name: system_configs system_configs_key_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.system_configs
    ADD CONSTRAINT system_configs_key_key UNIQUE (key);


--
-- TOC entry 3082 (class 2606 OID 67997)
-- Name: system_configs system_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.system_configs
    ADD CONSTRAINT system_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 3161 (class 2606 OID 69987)
-- Name: unit_conversions unit_conversions_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_pkey PRIMARY KEY (id);


--
-- TOC entry 3084 (class 2606 OID 68009)
-- Name: units units_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_code_key UNIQUE (code);


--
-- TOC entry 3086 (class 2606 OID 68007)
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- TOC entry 3151 (class 2606 OID 68297)
-- Name: inventory uq_inv_prod_wh; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT uq_inv_prod_wh UNIQUE (product_id, warehouse_id);


--
-- TOC entry 3163 (class 2606 OID 111934)
-- Name: unit_conversions uq_unit_conv; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT uq_unit_conv UNIQUE (product_id, from_unit_id, to_unit_id);


--
-- TOC entry 3165 (class 2606 OID 70031)
-- Name: user_permissions uq_user_module; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT uq_user_module UNIQUE (user_id, module);


--
-- TOC entry 3170 (class 2606 OID 91526)
-- Name: user_menu_overrides user_menu_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_menu_overrides
    ADD CONSTRAINT user_menu_overrides_pkey PRIMARY KEY (user_id, menu_id);


--
-- TOC entry 3167 (class 2606 OID 70029)
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3074 (class 2606 OID 67986)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3076 (class 2606 OID 67982)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3078 (class 2606 OID 67984)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3112 (class 2606 OID 68103)
-- Name: vat_records vat_records_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.vat_records
    ADD CONSTRAINT vat_records_pkey PRIMARY KEY (id);


--
-- TOC entry 3100 (class 2606 OID 68063)
-- Name: warehouses warehouses_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_code_key UNIQUE (code);


--
-- TOC entry 3102 (class 2606 OID 68061)
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- TOC entry 3168 (class 1259 OID 78240)
-- Name: idx_mv_balance; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_mv_balance ON public.mv_account_daily_balance USING btree (code, balance_date);


--
-- TOC entry 3193 (class 1259 OID 111943)
-- Name: ix_cart_session_status; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_cart_session_status ON public.cart USING btree (session_id, status);


--
-- TOC entry 3109 (class 1259 OID 111877)
-- Name: ix_debts_partner; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_debts_partner ON public.debts USING btree (partner_type, partner_id);


--
-- TOC entry 3110 (class 1259 OID 111878)
-- Name: ix_debts_status; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_debts_status ON public.debts USING btree (status);


--
-- TOC entry 3154 (class 1259 OID 111879)
-- Name: ix_inv_hist_created_at; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_inv_hist_created_at ON public.inventory_history USING btree (created_at);


--
-- TOC entry 3155 (class 1259 OID 111880)
-- Name: ix_inv_hist_product_wh; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_inv_hist_product_wh ON public.inventory_history USING btree (product_id, warehouse_id);


--
-- TOC entry 3134 (class 1259 OID 111881)
-- Name: ix_je_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_je_date ON public.journal_entries USING btree (date);


--
-- TOC entry 3135 (class 1259 OID 111882)
-- Name: ix_je_reference; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_je_reference ON public.journal_entries USING btree (reference_type, reference_id);


--
-- TOC entry 3202 (class 1259 OID 111942)
-- Name: ix_online_orders_created_at; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_online_orders_created_at ON public.online_orders USING btree (created_at);


--
-- TOC entry 3203 (class 1259 OID 111941)
-- Name: ix_online_orders_sync_status; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_online_orders_sync_status ON public.online_orders USING btree (sync_status);


--
-- TOC entry 3204 (class 1259 OID 102049)
-- Name: ix_online_orders_web_customer_id; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_online_orders_web_customer_id ON public.online_orders USING btree (web_customer_id);


--
-- TOC entry 3215 (class 1259 OID 111883)
-- Name: ix_product_images_product_id; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_product_images_product_id ON public.product_images USING btree (product_id);


--
-- TOC entry 3180 (class 1259 OID 111940)
-- Name: ix_product_listings_published; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_product_listings_published ON public.product_listings USING btree (is_published);


--
-- TOC entry 3113 (class 1259 OID 111892)
-- Name: ix_products_category_id; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_products_category_id ON public.products USING btree (category_id);


--
-- TOC entry 3114 (class 1259 OID 111893)
-- Name: ix_products_name; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_products_name ON public.products USING btree (name);


--
-- TOC entry 3171 (class 1259 OID 111899)
-- Name: ix_quotations_customer_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_quotations_customer_date ON public.quotations USING btree (customer_id, date);


--
-- TOC entry 3172 (class 1259 OID 111900)
-- Name: ix_quotations_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_quotations_date ON public.quotations USING btree (date);


--
-- TOC entry 3173 (class 1259 OID 111901)
-- Name: ix_quotations_status; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_quotations_status ON public.quotations USING btree (status);


--
-- TOC entry 3119 (class 1259 OID 111907)
-- Name: ix_stock_ins_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_stock_ins_date ON public.stock_ins USING btree (date);


--
-- TOC entry 3120 (class 1259 OID 111908)
-- Name: ix_stock_ins_status; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_stock_ins_status ON public.stock_ins USING btree (status);


--
-- TOC entry 3121 (class 1259 OID 111909)
-- Name: ix_stock_ins_supplier_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_stock_ins_supplier_date ON public.stock_ins USING btree (supplier_id, date);


--
-- TOC entry 3122 (class 1259 OID 111910)
-- Name: ix_stock_ins_warehouse_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_stock_ins_warehouse_date ON public.stock_ins USING btree (warehouse_id, date);


--
-- TOC entry 3127 (class 1259 OID 111925)
-- Name: ix_stock_outs_customer_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_stock_outs_customer_date ON public.stock_outs USING btree (customer_id, date);


--
-- TOC entry 3128 (class 1259 OID 111926)
-- Name: ix_stock_outs_date; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_stock_outs_date ON public.stock_outs USING btree (date);


--
-- TOC entry 3129 (class 1259 OID 111927)
-- Name: ix_stock_outs_status; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX ix_stock_outs_status ON public.stock_outs USING btree (status);


--
-- TOC entry 3232 (class 2606 OID 68077)
-- Name: account_charts account_charts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts
    ADD CONSTRAINT account_charts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.account_charts(id);


--
-- TOC entry 3281 (class 2606 OID 99790)
-- Name: cart cart_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3283 (class 2606 OID 111872)
-- Name: cart_items cart_items_cart_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES public.cart(id);


--
-- TOC entry 3284 (class 2606 OID 99812)
-- Name: cart_items cart_items_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.product_listings(id);


--
-- TOC entry 3285 (class 2606 OID 99817)
-- Name: cart_items cart_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3282 (class 2606 OID 99785)
-- Name: cart cart_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.customer_sessions(id);


--
-- TOC entry 3231 (class 2606 OID 68020)
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- TOC entry 3297 (class 2606 OID 99956)
-- Name: customer_accounts customer_accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_accounts
    ADD CONSTRAINT customer_accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3280 (class 2606 OID 99769)
-- Name: customer_sessions customer_sessions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customer_sessions
    ADD CONSTRAINT customer_sessions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3248 (class 2606 OID 68224)
-- Name: debt_payments debt_payments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3249 (class 2606 OID 68219)
-- Name: debt_payments debt_payments_debt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_debt_id_fkey FOREIGN KEY (debt_id) REFERENCES public.debts(id);


--
-- TOC entry 3298 (class 2606 OID 102063)
-- Name: product_images fk_product_images_product; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 3261 (class 2606 OID 68326)
-- Name: inventory_history inventory_history_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3262 (class 2606 OID 68316)
-- Name: inventory_history inventory_history_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3263 (class 2606 OID 68321)
-- Name: inventory_history inventory_history_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3259 (class 2606 OID 68298)
-- Name: inventory inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3260 (class 2606 OID 68303)
-- Name: inventory inventory_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3247 (class 2606 OID 68206)
-- Name: journal_entries journal_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3264 (class 2606 OID 68344)
-- Name: journal_lines journal_lines_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines
    ADD CONSTRAINT journal_lines_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account_charts(id);


--
-- TOC entry 3265 (class 2606 OID 68339)
-- Name: journal_lines journal_lines_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines
    ADD CONSTRAINT journal_lines_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES public.journal_entries(id);


--
-- TOC entry 3266 (class 2606 OID 68377)
-- Name: menu_roles menu_roles_menu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menu_roles
    ADD CONSTRAINT menu_roles_menu_id_fkey FOREIGN KEY (menu_id) REFERENCES public.menus(id) ON DELETE CASCADE;


--
-- TOC entry 3230 (class 2606 OID 67954)
-- Name: menus menus_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menus(id);


--
-- TOC entry 3294 (class 2606 OID 99927)
-- Name: online_order_items online_order_items_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_order_items
    ADD CONSTRAINT online_order_items_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.product_listings(id);


--
-- TOC entry 3295 (class 2606 OID 99922)
-- Name: online_order_items online_order_items_online_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_order_items
    ADD CONSTRAINT online_order_items_online_order_id_fkey FOREIGN KEY (online_order_id) REFERENCES public.online_orders(id) ON DELETE CASCADE;


--
-- TOC entry 3296 (class 2606 OID 99932)
-- Name: online_order_items online_order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_order_items
    ADD CONSTRAINT online_order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3289 (class 2606 OID 99897)
-- Name: online_orders online_orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders
    ADD CONSTRAINT online_orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3290 (class 2606 OID 99902)
-- Name: online_orders online_orders_promotion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders
    ADD CONSTRAINT online_orders_promotion_id_fkey FOREIGN KEY (promotion_id) REFERENCES public.promotions(id);


--
-- TOC entry 3291 (class 2606 OID 99892)
-- Name: online_orders online_orders_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders
    ADD CONSTRAINT online_orders_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.customer_sessions(id);


--
-- TOC entry 3292 (class 2606 OID 99907)
-- Name: online_orders online_orders_stock_out_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders
    ADD CONSTRAINT online_orders_stock_out_id_fkey FOREIGN KEY (stock_out_id) REFERENCES public.stock_outs(id);


--
-- TOC entry 3293 (class 2606 OID 102044)
-- Name: online_orders online_orders_web_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.online_orders
    ADD CONSTRAINT online_orders_web_customer_id_fkey FOREIGN KEY (web_customer_id) REFERENCES public.customer_accounts(id);


--
-- TOC entry 3250 (class 2606 OID 68247)
-- Name: opening_stocks opening_stocks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3251 (class 2606 OID 68237)
-- Name: opening_stocks opening_stocks_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3252 (class 2606 OID 68242)
-- Name: opening_stocks opening_stocks_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3279 (class 2606 OID 99749)
-- Name: product_listings product_listings_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.product_listings
    ADD CONSTRAINT product_listings_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3233 (class 2606 OID 68122)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 3234 (class 2606 OID 68355)
-- Name: products products_category_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey1 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 3235 (class 2606 OID 68117)
-- Name: products products_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3236 (class 2606 OID 68350)
-- Name: products products_unit_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_unit_id_fkey1 FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3276 (class 2606 OID 91605)
-- Name: quotation_items quotation_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3277 (class 2606 OID 111894)
-- Name: quotation_items quotation_items_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- TOC entry 3278 (class 2606 OID 91610)
-- Name: quotation_items quotation_items_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3273 (class 2606 OID 91582)
-- Name: quotations quotations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3274 (class 2606 OID 91572)
-- Name: quotations quotations_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3275 (class 2606 OID 91577)
-- Name: quotations quotations_stock_out_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_stock_out_id_fkey FOREIGN KEY (stock_out_id) REFERENCES public.stock_outs(id);


--
-- TOC entry 3286 (class 2606 OID 99865)
-- Name: reviews reviews_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3287 (class 2606 OID 99855)
-- Name: reviews reviews_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.product_listings(id);


--
-- TOC entry 3288 (class 2606 OID 99860)
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3253 (class 2606 OID 68265)
-- Name: stock_in_items stock_in_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT stock_in_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3254 (class 2606 OID 68260)
-- Name: stock_in_items stock_in_items_stock_in_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT stock_in_items_stock_in_id_fkey FOREIGN KEY (stock_in_id) REFERENCES public.stock_ins(id);


--
-- TOC entry 3255 (class 2606 OID 111902)
-- Name: stock_in_items stock_in_items_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT stock_in_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3237 (class 2606 OID 68155)
-- Name: stock_ins stock_ins_confirmed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_confirmed_by_fkey FOREIGN KEY (confirmed_by) REFERENCES public.users(id);


--
-- TOC entry 3238 (class 2606 OID 68150)
-- Name: stock_ins stock_ins_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3239 (class 2606 OID 68140)
-- Name: stock_ins stock_ins_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- TOC entry 3240 (class 2606 OID 111911)
-- Name: stock_ins stock_ins_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3241 (class 2606 OID 68145)
-- Name: stock_ins stock_ins_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3256 (class 2606 OID 68283)
-- Name: stock_out_items stock_out_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT stock_out_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3257 (class 2606 OID 68278)
-- Name: stock_out_items stock_out_items_stock_out_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT stock_out_items_stock_out_id_fkey FOREIGN KEY (stock_out_id) REFERENCES public.stock_outs(id);


--
-- TOC entry 3258 (class 2606 OID 111920)
-- Name: stock_out_items stock_out_items_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT stock_out_items_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3242 (class 2606 OID 68188)
-- Name: stock_outs stock_outs_confirmed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_confirmed_by_fkey FOREIGN KEY (confirmed_by) REFERENCES public.users(id);


--
-- TOC entry 3243 (class 2606 OID 68183)
-- Name: stock_outs stock_outs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3244 (class 2606 OID 68173)
-- Name: stock_outs stock_outs_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3245 (class 2606 OID 111928)
-- Name: stock_outs stock_outs_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3246 (class 2606 OID 68178)
-- Name: stock_outs stock_outs_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3303 (class 2606 OID 111834)
-- Name: stocktaking_items stocktaking_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktaking_items
    ADD CONSTRAINT stocktaking_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3304 (class 2606 OID 111829)
-- Name: stocktaking_items stocktaking_items_stocktaking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktaking_items
    ADD CONSTRAINT stocktaking_items_stocktaking_id_fkey FOREIGN KEY (stocktaking_id) REFERENCES public.stocktakings(id);


--
-- TOC entry 3299 (class 2606 OID 111816)
-- Name: stocktakings stocktakings_cancelled_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktakings
    ADD CONSTRAINT stocktakings_cancelled_by_fkey FOREIGN KEY (cancelled_by) REFERENCES public.users(id);


--
-- TOC entry 3300 (class 2606 OID 111811)
-- Name: stocktakings stocktakings_completed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktakings
    ADD CONSTRAINT stocktakings_completed_by_fkey FOREIGN KEY (completed_by) REFERENCES public.users(id);


--
-- TOC entry 3301 (class 2606 OID 111806)
-- Name: stocktakings stocktakings_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktakings
    ADD CONSTRAINT stocktakings_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3302 (class 2606 OID 111801)
-- Name: stocktakings stocktakings_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stocktakings
    ADD CONSTRAINT stocktakings_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3267 (class 2606 OID 69995)
-- Name: unit_conversions unit_conversions_from_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_from_unit_id_fkey FOREIGN KEY (from_unit_id) REFERENCES public.units(id);


--
-- TOC entry 3268 (class 2606 OID 69990)
-- Name: unit_conversions unit_conversions_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 3269 (class 2606 OID 70000)
-- Name: unit_conversions unit_conversions_to_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_to_unit_id_fkey FOREIGN KEY (to_unit_id) REFERENCES public.units(id);


--
-- TOC entry 3271 (class 2606 OID 91532)
-- Name: user_menu_overrides user_menu_overrides_menu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_menu_overrides
    ADD CONSTRAINT user_menu_overrides_menu_id_fkey FOREIGN KEY (menu_id) REFERENCES public.menus(id) ON DELETE CASCADE;


--
-- TOC entry 3272 (class 2606 OID 91527)
-- Name: user_menu_overrides user_menu_overrides_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_menu_overrides
    ADD CONSTRAINT user_menu_overrides_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3270 (class 2606 OID 111935)
-- Name: user_permissions user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: bamboo
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3483 (class 0 OID 78232)
-- Dependencies: 253 3517
-- Name: mv_account_daily_balance; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: bamboo
--

REFRESH MATERIALIZED VIEW public.mv_account_daily_balance;


-- Completed on 2026-07-22 17:37:04

--
-- PostgreSQL database dump complete
--

\unrestrict kRwcjZDIYkX2GbzbrSPCZpmSm4AOyisgLB1HegPdTfy8psGkC2hPBhExX1UH1cm

