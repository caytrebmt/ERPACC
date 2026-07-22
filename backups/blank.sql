--
-- PostgreSQL database dump
--

\restrict al9lBMWA2XcloKVdx51mObTUtftK6Hn0a0dV5UsKtfMg3854NpvASM6aMAxIrKG

-- Dumped from database version 12.4
-- Dumped by pg_dump version 18.0

-- Started on 2026-05-13 14:31:22

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
-- TOC entry 3220 (class 0 OID 0)
-- Dependencies: 220
-- Name: account_charts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.account_charts_id_seq OWNED BY public.account_charts.id;


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
-- TOC entry 3221 (class 0 OID 0)
-- Dependencies: 212
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


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
-- TOC entry 3222 (class 0 OID 0)
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
-- TOC entry 3223 (class 0 OID 0)
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
-- TOC entry 3224 (class 0 OID 0)
-- Dependencies: 222
-- Name: debts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.debts_id_seq OWNED BY public.debts.id;


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
-- TOC entry 3225 (class 0 OID 0)
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
-- TOC entry 3226 (class 0 OID 0)
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
-- TOC entry 3227 (class 0 OID 0)
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
-- TOC entry 3228 (class 0 OID 0)
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
-- TOC entry 3229 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.code; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.code IS 'Mã menu';


--
-- TOC entry 3230 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.name; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.name IS 'Tên menu';


--
-- TOC entry 3231 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.parent_id; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.parent_id IS 'Menu cha';


--
-- TOC entry 3232 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.url; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.url IS 'Đường dẫn URL';


--
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.icon; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.icon IS 'Icon FontAwesome';


--
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.order_no; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.order_no IS 'Thứ tự hiển thị';


--
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.module; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.module IS 'Module chức năng';


--
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN menus.roles; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.menus.roles IS 'Quyền truy cập (CSV)';


--
-- TOC entry 3237 (class 0 OID 0)
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
-- TOC entry 3238 (class 0 OID 0)
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
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.code; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.code IS 'Mã thông báo';


--
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.name; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.name IS 'Tên thông báo';


--
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.message_template; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.message_template IS 'Mẫu nội dung thông báo';


--
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 205
-- Name: COLUMN notifications.noti_type; Type: COMMENT; Schema: public; Owner: bamboo
--

COMMENT ON COLUMN public.notifications.noti_type IS 'Loại: success/error/warning/info';


--
-- TOC entry 3243 (class 0 OID 0)
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
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 204
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


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
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 236
-- Name: opening_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.opening_stocks_id_seq OWNED BY public.opening_stocks.id;


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
    image_url character varying(500),
    is_active boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 226
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


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
-- TOC entry 3247 (class 0 OID 0)
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
-- TOC entry 3248 (class 0 OID 0)
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
    box_note text
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
-- TOC entry 3249 (class 0 OID 0)
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
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 230
-- Name: stock_outs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.stock_outs_id_seq OWNED BY public.stock_outs.id;


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
-- TOC entry 3251 (class 0 OID 0)
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
-- TOC entry 3252 (class 0 OID 0)
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
    product_id integer,
    from_unit_id integer,
    to_unit_id integer,
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
-- TOC entry 3253 (class 0 OID 0)
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
-- TOC entry 3254 (class 0 OID 0)
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
-- TOC entry 3255 (class 0 OID 0)
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
-- TOC entry 3256 (class 0 OID 0)
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
-- TOC entry 3257 (class 0 OID 0)
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
-- TOC entry 3258 (class 0 OID 0)
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
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 218
-- Name: warehouses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bamboo
--

ALTER SEQUENCE public.warehouses_id_seq OWNED BY public.warehouses.id;


--
-- TOC entry 2868 (class 2604 OID 68069)
-- Name: account_charts id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts ALTER COLUMN id SET DEFAULT nextval('public.account_charts_id_seq'::regclass);


--
-- TOC entry 2864 (class 2604 OID 68015)
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- TOC entry 2866 (class 2604 OID 68043)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 2879 (class 2604 OID 68216)
-- Name: debt_payments id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments ALTER COLUMN id SET DEFAULT nextval('public.debt_payments_id_seq'::regclass);


--
-- TOC entry 2869 (class 2604 OID 68087)
-- Name: debts id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debts ALTER COLUMN id SET DEFAULT nextval('public.debts_id_seq'::regclass);


--
-- TOC entry 2885 (class 2604 OID 68293)
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- TOC entry 2886 (class 2604 OID 68313)
-- Name: inventory_history id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history ALTER COLUMN id SET DEFAULT nextval('public.inventory_history_id_seq'::regclass);


--
-- TOC entry 2878 (class 2604 OID 68198)
-- Name: journal_entries id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries ALTER COLUMN id SET DEFAULT nextval('public.journal_entries_id_seq'::regclass);


--
-- TOC entry 2887 (class 2604 OID 68336)
-- Name: journal_lines id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines ALTER COLUMN id SET DEFAULT nextval('public.journal_lines_id_seq'::regclass);


--
-- TOC entry 2859 (class 2604 OID 67946)
-- Name: menus id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus ALTER COLUMN id SET DEFAULT nextval('public.menus_id_seq'::regclass);


--
-- TOC entry 2860 (class 2604 OID 67964)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 2880 (class 2604 OID 68234)
-- Name: opening_stocks id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks ALTER COLUMN id SET DEFAULT nextval('public.opening_stocks_id_seq'::regclass);


--
-- TOC entry 2871 (class 2604 OID 68109)
-- Name: products id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- TOC entry 2881 (class 2604 OID 68257)
-- Name: stock_in_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items ALTER COLUMN id SET DEFAULT nextval('public.stock_in_items_id_seq'::regclass);


--
-- TOC entry 2872 (class 2604 OID 68132)
-- Name: stock_ins id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins ALTER COLUMN id SET DEFAULT nextval('public.stock_ins_id_seq'::regclass);


--
-- TOC entry 2883 (class 2604 OID 68275)
-- Name: stock_out_items id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items ALTER COLUMN id SET DEFAULT nextval('public.stock_out_items_id_seq'::regclass);


--
-- TOC entry 2874 (class 2604 OID 68165)
-- Name: stock_outs id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs ALTER COLUMN id SET DEFAULT nextval('public.stock_outs_id_seq'::regclass);


--
-- TOC entry 2865 (class 2604 OID 68030)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 2862 (class 2604 OID 67992)
-- Name: system_configs id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.system_configs ALTER COLUMN id SET DEFAULT nextval('public.system_configs_id_seq'::regclass);


--
-- TOC entry 2888 (class 2604 OID 69985)
-- Name: unit_conversions id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions ALTER COLUMN id SET DEFAULT nextval('public.unit_conversions_id_seq'::regclass);


--
-- TOC entry 2863 (class 2604 OID 68005)
-- Name: units id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- TOC entry 2889 (class 2604 OID 70023)
-- Name: user_permissions id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions ALTER COLUMN id SET DEFAULT nextval('public.user_permissions_id_seq'::regclass);


--
-- TOC entry 2861 (class 2604 OID 67977)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 2870 (class 2604 OID 68098)
-- Name: vat_records id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.vat_records ALTER COLUMN id SET DEFAULT nextval('public.vat_records_id_seq'::regclass);


--
-- TOC entry 2867 (class 2604 OID 68056)
-- Name: warehouses id; Type: DEFAULT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.warehouses ALTER COLUMN id SET DEFAULT nextval('public.warehouses_id_seq'::regclass);


--
-- TOC entry 3180 (class 0 OID 68066)
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
-- TOC entry 3172 (class 0 OID 68012)
-- Dependencies: 213
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.categories (id, code, name, parent_id, description, is_active, created_at) FROM stdin;
1	DIEN_TU	Điện tử	\N	\N	f	2026-03-17 06:49:16.405915
8	GIẤY A4	GIẤY A4	3		f	2026-04-23 04:35:34.239241
7	HANG_TD	Hàng tiêu dùng	\N	\N	f	2026-03-17 06:49:16.422475
2	LAPTOP	Laptop	1	\N	f	2026-03-17 06:49:16.409042
6	NGUYEN_LIEU	Nguyên vật liệu	\N	\N	f	2026-03-17 06:49:16.419293
5	O_TO	Ô tô - Xe máy	\N	\N	f	2026-03-17 06:49:16.416232
4	THUC_PHAM	Thực phẩm	\N	\N	f	2026-03-17 06:49:16.413186
3	VAN_PHONG	VPP	\N	None	t	2026-03-17 06:49:16.410985
\.


--
-- TOC entry 3176 (class 0 OID 68040)
-- Dependencies: 217
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.customers (id, code, name, short_name, customer_type, address, phone, email, tax_code, contact_person, bank_account, bank_name, bank_branch, payment_terms, credit_limit, discount_rate, note, is_active, created_at) FROM stdin;
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
-- TOC entry 3194 (class 0 OID 68213)
-- Dependencies: 235
-- Data for Name: debt_payments; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.debt_payments (id, debt_id, date, amount, payment_method, reference, note, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 3182 (class 0 OID 68084)
-- Dependencies: 223
-- Data for Name: debts; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.debts (id, partner_type, partner_id, reference_type, reference_id, reference_code, date, due_date, amount, paid_amount, balance, currency, status, note, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3202 (class 0 OID 68290)
-- Dependencies: 243
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.inventory (id, product_id, warehouse_id, quantity, avg_cost, last_updated) FROM stdin;
\.


--
-- TOC entry 3204 (class 0 OID 68310)
-- Dependencies: 245
-- Data for Name: inventory_history; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.inventory_history (id, product_id, warehouse_id, transaction_type, reference_code, quantity_change, quantity_before, quantity_after, unit_cost, note, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 3192 (class 0 OID 68195)
-- Dependencies: 233
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.journal_entries (id, code, date, description, reference_type, reference_id, reference_code, total_debit, total_credit, status, note, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 3206 (class 0 OID 68333)
-- Dependencies: 247
-- Data for Name: journal_lines; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.journal_lines (id, entry_id, account_id, description, debit, credit, partner_type, partner_id, order_no) FROM stdin;
\.


--
-- TOC entry 3207 (class 0 OID 68372)
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
12	admin
12	user
12	accountant
12	warehouse
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
\.


--
-- TOC entry 3162 (class 0 OID 67943)
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
27	OPENING_STOCK	Tồn đầu kỳ	2	/opening-stock/	fas fa-box-open	25	warehouse		t	2026-03-17 06:49:16.323642
33	RPT_REALTIME	Tồn kho realtime	31	/reports/realtime-inventory	fas fa-satellite-dish	62	reports		t	2026-03-17 06:49:16.333799
34	RPT_CUSTOMER	DT theo khách hàng	31	/reports/customer-revenue	fas fa-chart-line	63	reports		t	2026-03-17 06:49:16.335155
35	RPT_SUPPLIER	Nhập theo NCC	31	/reports/supplier-purchase	fas fa-truck	64	reports		t	2026-03-17 06:49:16.336497
1	DASHBOARD	Tổng quan	\N	/dashboard	fas fa-tachometer-alt	1	dashboard		t	2026-03-17 06:49:16.240265
29	CATEGORIES	Nhóm hàng hóa	2	/categories/	fas fa-tags	96	settings		t	2026-03-17 06:49:16.326878
28	UNITS	Đơn vị tính	2	/units/	fas fa-ruler	95	settings		t	2026-03-17 06:49:16.325457
37	SETTINGS_UNIT_CONVERSIONS	Quy đổi đơn vị	2	/settings/unit-conversions	fas fa-ruler-combined	97	settings		t	2026-03-25 14:08:31.097347
36	SETTINGS_DB	Backup / Restore DB	22	/settings/db/tools	fas fa-database	98	settings	\N	t	2026-03-22 06:49:16.336
39	ACCOUNTING_TT99_GROUP	Báo cáo	13	/accounting/balance-sheet	fas fa-file-invoice-dollar	65	accounting		t	2026-04-09 07:29:19.90271
41	ACCOUNTING_TT99_INCOME_STATEMENT	Báo cáo KQKD	13	/accounting/income-statement	fas fa-chart-line	67	accounting		t	2026-04-09 07:29:19.957224
13	ACCOUNTING	Kế toán	\N	\N	fas fa-calculator	5	accounting		t	2026-03-17 06:49:16.286579
42	ACCOUNTING_TT99_GENERAL_LEDGER	Sổ cái (TK 156)	13	/accounting/general-ledger/156	fas fa-book	68	accounting		t	2026-04-09 07:29:19.963271
2	WAREHOUSE	Kho hàng & Hàng hóa	\N	\N	fas fa-warehouse	2	warehouse		t	2026-03-17 06:49:16.24791
3	PRODUCTS	Hàng hóa	2	/products/	fas fa-box	21	warehouse		t	2026-03-17 06:49:16.250448
4	WAREHOUSES	Danh mục kho	2	/warehouses/	fas fa-building	22	warehouse		t	2026-03-17 06:49:16.255227
5	INVENTORY	Tồn kho (real-time)	2	/inventory/	fas fa-boxes	23	warehouse		t	2026-03-17 06:49:16.257884
6	INVENTORY_HIST	Lịch sử biến động	2	/inventory/history	fas fa-history	24	warehouse		t	2026-03-17 06:49:16.260533
7	PURCHASE	Mua hàng	\N	\N	fas fa-shopping-cart	3	purchase		t	2026-03-17 06:49:16.265179
8	SUPPLIERS	Nhà cung cấp	7	/suppliers/	fas fa-truck	31	purchase		t	2026-03-17 06:49:16.268285
9	STOCK_IN	Phiếu nhập kho	7	/stock-in/	fas fa-arrow-circle-down	32	purchase		t	2026-03-17 06:49:16.272178
10	SALES	Bán hàng	\N	\N	fas fa-store	4	sales		t	2026-03-17 06:49:16.275459
11	CUSTOMERS	Khách hàng	10	/customers/	fas fa-users	41	sales		t	2026-03-17 06:49:16.279075
12	STOCK_OUT	Phiếu xuất kho	10	/stock-out/	fas fa-arrow-circle-up	42	sales		t	2026-03-17 06:49:16.282821
40	ACCOUNTING_TT99_BALANCE_SHEET	TT99 - Bảng cân đối kế toán	13	/accounting/balance-sheet	fas fa-scale-balanced	66	accounting		f	2026-04-09 07:29:19.951863
30	COMPANY_INFO	Thông tin công ty	22	/company/	fas fa-building	90	settings		t	2026-03-17 06:49:16.328407
31	REPORTS	Báo cáo	\N	\N	fas fa-chart-bar	6	reports		t	2026-03-17 06:49:16.330447
32	RPT_MOVEMENT	Sổ nhập xuất tồn	31	/reports/stock-movement	fas fa-exchange-alt	61	reports		t	2026-03-17 06:49:16.33227
38	Mapping Account	Mapping tài khoản	13	/accounting/account-mapping	fas fa-link me-2	99	accounting	\N	t	2026-03-17 06:49:16.240265
43	ACCOUNTING_TT99_DETAIL_LEDGER	Sổ chi tiết (TK 131)	13	/accounting/detail-ledger/131	fas fa-list-alt	69	accounting		t	2026-04-09 07:29:19.969086
22	SETTINGS	Cài đặt	\N	None	fas fa-cogs	9	settings		t	2026-03-17 06:49:16.313879
\.


--
-- TOC entry 3164 (class 0 OID 67961)
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
-- TOC entry 3196 (class 0 OID 68231)
-- Dependencies: 237
-- Data for Name: opening_stocks; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.opening_stocks (id, period_date, product_id, warehouse_id, quantity, unit_cost, amount, note, is_posted, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 3186 (class 0 OID 68106)
-- Dependencies: 227
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.products (id, code, barcode, name, name_en, unit_id, unit, category_id, category, purchase_price, sale_price, vat_rate, min_stock, max_stock, allow_negative, description, image_url, is_active, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3198 (class 0 OID 68254)
-- Dependencies: 239
-- Data for Name: stock_in_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_in_items (id, stock_in_id, product_id, quantity, unit_price, vat_rate, vat_amount, amount, total_amount, note, unit_id, conversion_factor) FROM stdin;
\.


--
-- TOC entry 3188 (class 0 OID 68129)
-- Dependencies: 229
-- Data for Name: stock_ins; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_ins (id, code, date, supplier_id, warehouse_id, invoice_no, invoice_series, invoice_date, reference, subtotal, discount_pct, discount_amount, vat_amount, total_amount, paid_amount, vat_manual, vat_manual_val, status, note, created_by, confirmed_by, confirmed_at, created_at, updated_at, unit_id, conversion_factor) FROM stdin;
\.


--
-- TOC entry 3200 (class 0 OID 68272)
-- Dependencies: 241
-- Data for Name: stock_out_items; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_out_items (id, stock_out_id, product_id, quantity, unit_price, cost_price, vat_rate, vat_amount, amount, total_amount, note, unit_id, conversion_factor, box_note) FROM stdin;
\.


--
-- TOC entry 3190 (class 0 OID 68162)
-- Dependencies: 231
-- Data for Name: stock_outs; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.stock_outs (id, code, date, customer_id, warehouse_id, invoice_no, invoice_series, reference, subtotal, discount_pct, discount_amount, vat_amount, total_amount, paid_amount, vat_manual, vat_manual_val, status, note, created_by, confirmed_by, confirmed_at, created_at, updated_at, unit_id, conversion_factor, vat_mode, vat_rate_grouped) FROM stdin;
\.


--
-- TOC entry 3174 (class 0 OID 68027)
-- Dependencies: 215
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.suppliers (id, code, name, short_name, address, phone, fax, email, website, tax_code, contact_person, bank_account, bank_name, bank_branch, payment_terms, credit_limit, note, is_active, created_at) FROM stdin;
1	NCC001	Công ty CP Phân phối FPT	\N	261 Cầu Giấy, Hà Nội	024-7300-7300	\N	fpt@example.com	\N	0101234567	\N	\N	\N	\N	30	0.00	\N	t	2026-03-17 06:49:16.832727
2	NCC002	Công ty TNHH Samsung Vina	\N	Khu CN Yên Phong, Bắc Ninh	0222-1234-567	\N	samsung@example.com	\N	2300123456	\N	\N	\N	\N	30	0.00	\N	t	2026-03-17 06:49:16.835225
3	NCC003	Cty CP Văn phòng phẩm Thiên Long	\N	43 Đốc Ngữ, Q5, TP.HCM	028-3835-3835	\N	thienlongvpp@example.com	\N	0302345678	\N	\N	\N	\N	30	0.00	\N	t	2026-03-17 06:49:16.836717
4	NCC004	Công ty TNHH Shell Việt Nam	\N	47 Đinh Tiên Hoàng, Q1, TP.HCM	028-3521-3456	\N	shell@example.com	\N	0304567890	\N	\N	\N	\N	30	0.00	\N	t	2026-03-17 06:49:16.83829
5	NCC005	CUNG CẤP THỰC PHẨM ABC											\N	30	0.00		t	2026-03-19 15:59:42.750757
\.


--
-- TOC entry 3168 (class 0 OID 67989)
-- Dependencies: 209
-- Data for Name: system_configs; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.system_configs (id, key, value, description, group_name, updated_at) FROM stdin;
8	default_vat_rate	10	Thuế suất VAT mặc định (%)	accounting	2026-03-17 06:49:16.214447
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
6	company_tax_code	0903671304	Mã số thuế	company	2026-03-21 09:48:31.918119
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
30	acc_inventory	156	Hàng hóa	accounting	2026-04-09 03:36:05.104483
31	acc_vat_in	1331	Thuế GTGT được khấu trừ của hàng hóa, dịch vụ	accounting	2026-04-09 03:36:05.106918
32	acc_vat_out	3331	Thuế giá trị gia tăng phải nộp	accounting	2026-04-09 03:36:05.109225
33	acc_revenue	511	Doanh thu bán hàng và cung cấp dịch vụ	accounting	2026-04-09 03:36:05.111284
34	acc_cogs	632	Giá vốn hàng bán	accounting	2026-04-09 03:36:05.113282
19	company_director		Giám đốc	company	2026-05-12 12:31:48.579715
\.


--
-- TOC entry 3209 (class 0 OID 69982)
-- Dependencies: 250
-- Data for Name: unit_conversions; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.unit_conversions (id, product_id, from_unit_id, to_unit_id, conversion_factor) FROM stdin;
\.


--
-- TOC entry 3170 (class 0 OID 68002)
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
-- TOC entry 3213 (class 0 OID 91522)
-- Dependencies: 254
-- Data for Name: user_menu_overrides; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.user_menu_overrides (user_id, menu_id, is_visible) FROM stdin;
3	13	f
3	22	f
\.


--
-- TOC entry 3211 (class 0 OID 70020)
-- Dependencies: 252
-- Data for Name: user_permissions; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.user_permissions (id, user_id, module, can_view, can_add, can_edit, can_delete) FROM stdin;
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
78	3	dashboard	t	f	f	f
79	3	products	t	t	t	t
80	3	suppliers	t	t	t	t
81	3	customers	t	t	t	t
82	3	stock_in	t	t	t	t
83	3	stock_out	t	t	t	t
84	3	inventory	t	t	t	t
85	3	debt	t	t	t	t
86	3	accounting	f	f	f	f
87	3	reports	t	t	t	t
88	3	settings	f	f	f	f
\.


--
-- TOC entry 3166 (class 0 OID 67974)
-- Dependencies: 207
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.users (id, username, email, password_hash, full_name, role, is_active, last_login, created_at) FROM stdin;
4	user	user@erpviet.com	scrypt:32768:8:1$qiGHIFwgJHybNGGF$e9b1c0d2ec396786cd377356934231728498103bce24281206757d4a1bae877e3a2c84ce2abd7ec74a86dca065353d661bdb09c8cee01f52dd833628dc68c517	User	user	t	2026-03-24 15:46:21.082674	2026-03-18 06:23:15.031895
2	ketoan	ketoan@erpviet.com	scrypt:32768:8:1$oA2AzIvzKrqtpxUa$ea45a35b2bc2599e5961bdd78c432c54cb85d30492d56967ceb591fe12263ed2fd1f3431a8c5d6621fb3b0458854bb5769ca17247f4de9f6063f4027de49e839	Kế toán viên	accountant	t	2026-04-09 11:07:33.238391	2026-03-17 06:49:16.725414
3	kho	kho@erpviet.com	scrypt:32768:8:1$JLFLpDGPPEIw3lSJ$508650f5003c16121640e4528c3b8726f7141487a830c81fedfdecd6407417a211010abe700a1e0554cb6431e609a2cdabc25be6366ede964cc5410af448b4e3	Thủ Kho	warehouse	t	2026-05-12 16:02:45.86129	2026-03-17 17:03:57.089286
1	admin	cg3090@gmail.com	scrypt:32768:8:1$Jk6qHq4wSUqKaVHt$901372a1331526cf48e3f83f30a22685ab6612210d6ce99d364129a72edf8df4fbfb449bca00b4de0647e834e4f43d88322600f4e6b53ca5369c244dc3ce54c9	Quản trị viên	admin	t	2026-05-13 07:23:31.143254	2026-03-17 06:49:16.725409
\.


--
-- TOC entry 3184 (class 0 OID 68095)
-- Dependencies: 225
-- Data for Name: vat_records; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.vat_records (id, vat_type, date, invoice_no, invoice_series, reference_type, reference_id, reference_code, partner_name, partner_tax_code, partner_address, taxable_amount, vat_rate, vat_amount, total_amount, is_deductible, period_month, period_year, note, created_at) FROM stdin;
\.


--
-- TOC entry 3178 (class 0 OID 68053)
-- Dependencies: 219
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: bamboo
--

COPY public.warehouses (id, code, name, address, manager, phone, is_active, created_at) FROM stdin;
2	KHO_HCM	Kho TP.HCM	TP.HCM	Trần V	028-9876-5432	t	2026-03-17 06:49:16.734986
\.


--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 220
-- Name: account_charts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.account_charts_id_seq', 107, true);


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 212
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.categories_id_seq', 8, true);


--
-- TOC entry 3262 (class 0 OID 0)
-- Dependencies: 216
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.customers_id_seq', 288, true);


--
-- TOC entry 3263 (class 0 OID 0)
-- Dependencies: 234
-- Name: debt_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.debt_payments_id_seq', 1, false);


--
-- TOC entry 3264 (class 0 OID 0)
-- Dependencies: 222
-- Name: debts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.debts_id_seq', 1, false);


--
-- TOC entry 3265 (class 0 OID 0)
-- Dependencies: 244
-- Name: inventory_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.inventory_history_id_seq', 111, true);


--
-- TOC entry 3266 (class 0 OID 0)
-- Dependencies: 242
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.inventory_id_seq', 114, true);


--
-- TOC entry 3267 (class 0 OID 0)
-- Dependencies: 232
-- Name: journal_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.journal_entries_id_seq', 1, false);


--
-- TOC entry 3268 (class 0 OID 0)
-- Dependencies: 246
-- Name: journal_lines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.journal_lines_id_seq', 1, false);


--
-- TOC entry 3269 (class 0 OID 0)
-- Dependencies: 202
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.menus_id_seq', 43, true);


--
-- TOC entry 3270 (class 0 OID 0)
-- Dependencies: 204
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.notifications_id_seq', 14, true);


--
-- TOC entry 3271 (class 0 OID 0)
-- Dependencies: 236
-- Name: opening_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.opening_stocks_id_seq', 111, true);


--
-- TOC entry 3272 (class 0 OID 0)
-- Dependencies: 226
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.products_id_seq', 177, true);


--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 238
-- Name: stock_in_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_in_items_id_seq', 1, false);


--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 228
-- Name: stock_ins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_ins_id_seq', 1, false);


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 240
-- Name: stock_out_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_out_items_id_seq', 1, true);


--
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 230
-- Name: stock_outs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.stock_outs_id_seq', 1, true);


--
-- TOC entry 3277 (class 0 OID 0)
-- Dependencies: 214
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);


--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 208
-- Name: system_configs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.system_configs_id_seq', 34, true);


--
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 249
-- Name: unit_conversions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.unit_conversions_id_seq', 4, true);


--
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 210
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.units_id_seq', 19, true);


--
-- TOC entry 3281 (class 0 OID 0)
-- Dependencies: 251
-- Name: user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.user_permissions_id_seq', 88, true);


--
-- TOC entry 3282 (class 0 OID 0)
-- Dependencies: 206
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 3283 (class 0 OID 0)
-- Dependencies: 224
-- Name: vat_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.vat_records_id_seq', 1, false);


--
-- TOC entry 3284 (class 0 OID 0)
-- Dependencies: 218
-- Name: warehouses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bamboo
--

SELECT pg_catalog.setval('public.warehouses_id_seq', 3, true);


--
-- TOC entry 2933 (class 2606 OID 68076)
-- Name: account_charts account_charts_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts
    ADD CONSTRAINT account_charts_code_key UNIQUE (code);


--
-- TOC entry 2935 (class 2606 OID 68074)
-- Name: account_charts account_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts
    ADD CONSTRAINT account_charts_pkey PRIMARY KEY (id);


--
-- TOC entry 2917 (class 2606 OID 68019)
-- Name: categories categories_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_code_key UNIQUE (code);


--
-- TOC entry 2919 (class 2606 OID 68017)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 2925 (class 2606 OID 68050)
-- Name: customers customers_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_code_key UNIQUE (code);


--
-- TOC entry 2927 (class 2606 OID 68048)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 2960 (class 2606 OID 68218)
-- Name: debt_payments debt_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_pkey PRIMARY KEY (id);


--
-- TOC entry 2938 (class 2606 OID 68092)
-- Name: debts debts_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debts
    ADD CONSTRAINT debts_pkey PRIMARY KEY (id);


--
-- TOC entry 2972 (class 2606 OID 68315)
-- Name: inventory_history inventory_history_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_pkey PRIMARY KEY (id);


--
-- TOC entry 2968 (class 2606 OID 68295)
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- TOC entry 2956 (class 2606 OID 68205)
-- Name: journal_entries journal_entries_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_code_key UNIQUE (code);


--
-- TOC entry 2958 (class 2606 OID 68203)
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 2976 (class 2606 OID 68338)
-- Name: journal_lines journal_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines
    ADD CONSTRAINT journal_lines_pkey PRIMARY KEY (id);


--
-- TOC entry 2979 (class 2606 OID 68376)
-- Name: menu_roles menu_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menu_roles
    ADD CONSTRAINT menu_roles_pkey PRIMARY KEY (menu_id, role);


--
-- TOC entry 2895 (class 2606 OID 67953)
-- Name: menus menus_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_code_key UNIQUE (code);


--
-- TOC entry 2897 (class 2606 OID 67951)
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- TOC entry 2899 (class 2606 OID 67971)
-- Name: notifications notifications_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_code_key UNIQUE (code);


--
-- TOC entry 2901 (class 2606 OID 67969)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 2962 (class 2606 OID 68236)
-- Name: opening_stocks opening_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_pkey PRIMARY KEY (id);


--
-- TOC entry 2942 (class 2606 OID 68116)
-- Name: products products_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_code_key UNIQUE (code);


--
-- TOC entry 2944 (class 2606 OID 68114)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 2964 (class 2606 OID 68259)
-- Name: stock_in_items stock_in_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT stock_in_items_pkey PRIMARY KEY (id);


--
-- TOC entry 2946 (class 2606 OID 68139)
-- Name: stock_ins stock_ins_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_code_key UNIQUE (code);


--
-- TOC entry 2948 (class 2606 OID 68137)
-- Name: stock_ins stock_ins_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_pkey PRIMARY KEY (id);


--
-- TOC entry 2966 (class 2606 OID 68277)
-- Name: stock_out_items stock_out_items_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT stock_out_items_pkey PRIMARY KEY (id);


--
-- TOC entry 2950 (class 2606 OID 68172)
-- Name: stock_outs stock_outs_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_code_key UNIQUE (code);


--
-- TOC entry 2952 (class 2606 OID 68170)
-- Name: stock_outs stock_outs_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_pkey PRIMARY KEY (id);


--
-- TOC entry 2921 (class 2606 OID 68037)
-- Name: suppliers suppliers_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_code_key UNIQUE (code);


--
-- TOC entry 2923 (class 2606 OID 68035)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- TOC entry 2909 (class 2606 OID 67999)
-- Name: system_configs system_configs_key_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.system_configs
    ADD CONSTRAINT system_configs_key_key UNIQUE (key);


--
-- TOC entry 2911 (class 2606 OID 67997)
-- Name: system_configs system_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.system_configs
    ADD CONSTRAINT system_configs_pkey PRIMARY KEY (id);


--
-- TOC entry 2981 (class 2606 OID 69987)
-- Name: unit_conversions unit_conversions_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_pkey PRIMARY KEY (id);


--
-- TOC entry 2983 (class 2606 OID 69989)
-- Name: unit_conversions unit_conversions_product_id_from_unit_id_to_unit_id_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_product_id_from_unit_id_to_unit_id_key UNIQUE (product_id, from_unit_id, to_unit_id);


--
-- TOC entry 2913 (class 2606 OID 68009)
-- Name: units units_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_code_key UNIQUE (code);


--
-- TOC entry 2915 (class 2606 OID 68007)
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- TOC entry 2970 (class 2606 OID 68297)
-- Name: inventory uq_inv_prod_wh; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT uq_inv_prod_wh UNIQUE (product_id, warehouse_id);


--
-- TOC entry 2985 (class 2606 OID 70031)
-- Name: user_permissions uq_user_module; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT uq_user_module UNIQUE (user_id, module);


--
-- TOC entry 2990 (class 2606 OID 91526)
-- Name: user_menu_overrides user_menu_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_menu_overrides
    ADD CONSTRAINT user_menu_overrides_pkey PRIMARY KEY (user_id, menu_id);


--
-- TOC entry 2987 (class 2606 OID 70029)
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2903 (class 2606 OID 67986)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 2905 (class 2606 OID 67982)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2907 (class 2606 OID 67984)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 2940 (class 2606 OID 68103)
-- Name: vat_records vat_records_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.vat_records
    ADD CONSTRAINT vat_records_pkey PRIMARY KEY (id);


--
-- TOC entry 2929 (class 2606 OID 68063)
-- Name: warehouses warehouses_code_key; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_code_key UNIQUE (code);


--
-- TOC entry 2931 (class 2606 OID 68061)
-- Name: warehouses warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.warehouses
    ADD CONSTRAINT warehouses_pkey PRIMARY KEY (id);


--
-- TOC entry 2936 (class 1259 OID 78231)
-- Name: idx_ac_code_active; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_ac_code_active ON public.account_charts USING btree (code) WHERE (is_active = true);


--
-- TOC entry 2953 (class 1259 OID 78227)
-- Name: idx_je_date_status; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_je_date_status ON public.journal_entries USING btree (date, status) WHERE ((status)::text = 'posted'::text);


--
-- TOC entry 2954 (class 1259 OID 78228)
-- Name: idx_je_reference; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_je_reference ON public.journal_entries USING btree (reference_type, reference_id);


--
-- TOC entry 2973 (class 1259 OID 78229)
-- Name: idx_jl_account; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_jl_account ON public.journal_lines USING btree (account_id);


--
-- TOC entry 2974 (class 1259 OID 78230)
-- Name: idx_jl_partner; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_jl_partner ON public.journal_lines USING btree (partner_id) WHERE (partner_id IS NOT NULL);


--
-- TOC entry 2977 (class 1259 OID 70017)
-- Name: idx_menu_roles_role; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_menu_roles_role ON public.menu_roles USING btree (role);


--
-- TOC entry 2988 (class 1259 OID 78240)
-- Name: idx_mv_balance; Type: INDEX; Schema: public; Owner: bamboo
--

CREATE INDEX idx_mv_balance ON public.mv_account_daily_balance USING btree (code, balance_date);


--
-- TOC entry 2993 (class 2606 OID 68077)
-- Name: account_charts account_charts_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.account_charts
    ADD CONSTRAINT account_charts_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.account_charts(id);


--
-- TOC entry 2992 (class 2606 OID 68020)
-- Name: categories categories_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categories(id);


--
-- TOC entry 3009 (class 2606 OID 68224)
-- Name: debt_payments debt_payments_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3010 (class 2606 OID 68219)
-- Name: debt_payments debt_payments_debt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.debt_payments
    ADD CONSTRAINT debt_payments_debt_id_fkey FOREIGN KEY (debt_id) REFERENCES public.debts(id);


--
-- TOC entry 2998 (class 2606 OID 69942)
-- Name: stock_ins fk_stock_ins_unit; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT fk_stock_ins_unit FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE SET NULL;


--
-- TOC entry 3003 (class 2606 OID 69948)
-- Name: stock_outs fk_stock_ins_unit; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT fk_stock_ins_unit FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE SET NULL;


--
-- TOC entry 3014 (class 2606 OID 70006)
-- Name: stock_in_items fk_stock_ins_unit; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT fk_stock_ins_unit FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE SET NULL;


--
-- TOC entry 3017 (class 2606 OID 70012)
-- Name: stock_out_items fk_stock_ins_unit; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT fk_stock_ins_unit FOREIGN KEY (unit_id) REFERENCES public.units(id) ON DELETE SET NULL;


--
-- TOC entry 3022 (class 2606 OID 68326)
-- Name: inventory_history inventory_history_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3023 (class 2606 OID 68316)
-- Name: inventory_history inventory_history_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3024 (class 2606 OID 68321)
-- Name: inventory_history inventory_history_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory_history
    ADD CONSTRAINT inventory_history_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3020 (class 2606 OID 68298)
-- Name: inventory inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3021 (class 2606 OID 68303)
-- Name: inventory inventory_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3008 (class 2606 OID 68206)
-- Name: journal_entries journal_entries_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_entries
    ADD CONSTRAINT journal_entries_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3025 (class 2606 OID 68344)
-- Name: journal_lines journal_lines_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines
    ADD CONSTRAINT journal_lines_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account_charts(id);


--
-- TOC entry 3026 (class 2606 OID 68339)
-- Name: journal_lines journal_lines_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.journal_lines
    ADD CONSTRAINT journal_lines_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES public.journal_entries(id);


--
-- TOC entry 3027 (class 2606 OID 68377)
-- Name: menu_roles menu_roles_menu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menu_roles
    ADD CONSTRAINT menu_roles_menu_id_fkey FOREIGN KEY (menu_id) REFERENCES public.menus(id) ON DELETE CASCADE;


--
-- TOC entry 2991 (class 2606 OID 67954)
-- Name: menus menus_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menus(id);


--
-- TOC entry 3011 (class 2606 OID 68247)
-- Name: opening_stocks opening_stocks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3012 (class 2606 OID 68237)
-- Name: opening_stocks opening_stocks_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3013 (class 2606 OID 68242)
-- Name: opening_stocks opening_stocks_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.opening_stocks
    ADD CONSTRAINT opening_stocks_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 2994 (class 2606 OID 68122)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 2995 (class 2606 OID 68355)
-- Name: products products_category_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey1 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 2996 (class 2606 OID 68117)
-- Name: products products_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 2997 (class 2606 OID 68350)
-- Name: products products_unit_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_unit_id_fkey1 FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- TOC entry 3015 (class 2606 OID 68265)
-- Name: stock_in_items stock_in_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT stock_in_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3016 (class 2606 OID 68260)
-- Name: stock_in_items stock_in_items_stock_in_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_in_items
    ADD CONSTRAINT stock_in_items_stock_in_id_fkey FOREIGN KEY (stock_in_id) REFERENCES public.stock_ins(id);


--
-- TOC entry 2999 (class 2606 OID 68155)
-- Name: stock_ins stock_ins_confirmed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_confirmed_by_fkey FOREIGN KEY (confirmed_by) REFERENCES public.users(id);


--
-- TOC entry 3000 (class 2606 OID 68150)
-- Name: stock_ins stock_ins_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3001 (class 2606 OID 68140)
-- Name: stock_ins stock_ins_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- TOC entry 3002 (class 2606 OID 68145)
-- Name: stock_ins stock_ins_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_ins
    ADD CONSTRAINT stock_ins_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3018 (class 2606 OID 68283)
-- Name: stock_out_items stock_out_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT stock_out_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3019 (class 2606 OID 68278)
-- Name: stock_out_items stock_out_items_stock_out_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_out_items
    ADD CONSTRAINT stock_out_items_stock_out_id_fkey FOREIGN KEY (stock_out_id) REFERENCES public.stock_outs(id);


--
-- TOC entry 3004 (class 2606 OID 68188)
-- Name: stock_outs stock_outs_confirmed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_confirmed_by_fkey FOREIGN KEY (confirmed_by) REFERENCES public.users(id);


--
-- TOC entry 3005 (class 2606 OID 68183)
-- Name: stock_outs stock_outs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3006 (class 2606 OID 68173)
-- Name: stock_outs stock_outs_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 3007 (class 2606 OID 68178)
-- Name: stock_outs stock_outs_warehouse_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.stock_outs
    ADD CONSTRAINT stock_outs_warehouse_id_fkey FOREIGN KEY (warehouse_id) REFERENCES public.warehouses(id);


--
-- TOC entry 3028 (class 2606 OID 69995)
-- Name: unit_conversions unit_conversions_from_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_from_unit_id_fkey FOREIGN KEY (from_unit_id) REFERENCES public.units(id);


--
-- TOC entry 3029 (class 2606 OID 69990)
-- Name: unit_conversions unit_conversions_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 3030 (class 2606 OID 70000)
-- Name: unit_conversions unit_conversions_to_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.unit_conversions
    ADD CONSTRAINT unit_conversions_to_unit_id_fkey FOREIGN KEY (to_unit_id) REFERENCES public.units(id);


--
-- TOC entry 3032 (class 2606 OID 91532)
-- Name: user_menu_overrides user_menu_overrides_menu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_menu_overrides
    ADD CONSTRAINT user_menu_overrides_menu_id_fkey FOREIGN KEY (menu_id) REFERENCES public.menus(id) ON DELETE CASCADE;


--
-- TOC entry 3033 (class 2606 OID 91527)
-- Name: user_menu_overrides user_menu_overrides_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_menu_overrides
    ADD CONSTRAINT user_menu_overrides_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3031 (class 2606 OID 70032)
-- Name: user_permissions user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bamboo
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3219 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: bamboo
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3212 (class 0 OID 78232)
-- Dependencies: 253 3215
-- Name: mv_account_daily_balance; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: bamboo
--

REFRESH MATERIALIZED VIEW public.mv_account_daily_balance;


-- Completed on 2026-05-13 14:31:23

--
-- PostgreSQL database dump complete
--

\unrestrict al9lBMWA2XcloKVdx51mObTUtftK6Hn0a0dV5UsKtfMg3854NpvASM6aMAxIrKG

