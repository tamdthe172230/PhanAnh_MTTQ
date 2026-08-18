<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <% String ctx=request.getContextPath(); jakarta.servlet.http.HttpSession pageSession=request.getSession(false);
            boolean isAdmin=(pageSession !=null && "admin" .equals(pageSession.getAttribute("role"))); %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta name="description"
                    content="Hệ thống tiếp nhận, xử lý phản ánh kiến nghị của nhân dân - Ủy ban MTTQ Việt Nam Phường Liên Hòa">
                <title>Phản ánh - Kiến nghị | MTTQ Phường Liên Hòa</title>
                <link rel="icon" href="<%= ctx %>/assets/logo.png" type="image/png">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <!-- ExcelJS for client-side Excel export (giống AI_Task_Dispatcher) -->
                <script src="https://cdn.jsdelivr.net/npm/exceljs@4.4.0/dist/exceljs.min.js"></script>
                <style>
                    *,
                    *::before,
                    *::after {
                        box-sizing: border-box;
                        margin: 0;
                        padding: 0;
                    }

                    :root {
                        --red: #BB032A;
                        --red-dark: #96001f;
                        --red-light: #fff0f3;
                        --text: #212529;
                        --muted: #6c757d;
                        --border: #dee2e6;
                        --bg: #f8f9fa;
                        --white: #ffffff;
                        --radius: 4px;
                        --shadow: 0 2px 8px rgba(0, 0, 0, .08);
                    }

                    body {
                        font-family: 'Inter', 'Segoe UI', sans-serif;
                        background: var(--bg);
                        color: var(--text);
                        font-size: 14px;
                        min-height: 100vh;
                    }

                    /* ── HEADER BANNER ── */
                    .site-banner {
                        background: linear-gradient(135deg, #b5000b 0%, #96001f 40%, #c0392b 100%);
                        padding: 24px 0;
                        box-shadow: inset 0 -4px 10px rgba(0, 0, 0, .15);
                    }

                    .banner-inner {
                        max-width: 1360px;
                        margin: 0 auto;
                        padding: 0 24px;
                        width: 100%;
                        display: flex;
                        align-items: center;
                        gap: 24px;
                    }

                    .banner-logo {
                        width: 96px;
                        height: 96px;
                        flex-shrink: 0;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, .15);
                        border: 3px solid rgba(255, 255, 255, .4);
                        box-shadow: 0 4px 12px rgba(0, 0, 0, .2);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 3rem;
                    }

                    .banner-logo img {
                        width: 90px;
                        height: 90px;
                        border-radius: 50%;
                        object-fit: cover;
                    }

                    .banner-text {
                        color: #fff;
                    }

                    .banner-text h1 {
                        font-size: 1.75rem;
                        font-weight: 800;
                        letter-spacing: .5px;
                        text-transform: uppercase;
                        line-height: 1.25;
                        text-shadow: 0 2px 4px rgba(0, 0, 0, .2);
                    }

                    .banner-text p {
                        font-size: .95rem;
                        font-weight: 700;
                        color: #ffd54f;
                        letter-spacing: 1.2px;
                        text-transform: uppercase;
                        margin-top: 6px;
                        text-shadow: 0 1px 2px rgba(0, 0, 0, .2);
                    }

                    /* ── NAVBAR ── */
                    .site-navbar {
                        background: #b5000b;
                        border-top: 1px solid rgba(255, 255, 255, .15);
                    }

                    .navbar-inner {
                        max-width: 1360px;
                        margin: 0 auto;
                        padding: 0 24px;
                        width: 100%;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .nav-links {
                        list-style: none;
                        display: flex;
                    }

                    .nav-links li a {
                        display: block;
                        padding: 15px 22px;
                        color: rgba(255, 255, 255, .92);
                        font-weight: 700;
                        font-size: .98rem;
                        text-decoration: none;
                        transition: background .15s;
                        border-radius: 0;
                    }

                    .nav-links li a:hover {
                        background: rgba(255, 255, 255, .15);
                        color: #fff;
                    }

                    .nav-links li a.active {
                        background: rgba(255, 255, 255, .25);
                        color: #fff;
                    }

                    .btn-login {
                        padding: 8px 20px;
                        border: 1.5px solid rgba(255, 255, 255, .8);
                        color: #fff;
                        background: transparent;
                        border-radius: 6px;
                        font-size: .9rem;
                        font-weight: 700;
                        text-decoration: none;
                        transition: all .15s;
                    }

                    .btn-login:hover {
                        background: rgba(255, 255, 255, .2);
                        color: #fff;
                    }

                    /* ── MAIN ── */
                    .page-wrap {
                        max-width: 1360px;
                        margin: 35px auto 70px;
                        padding: 0 24px;
                        width: 100%;
                    }

                    .page-title {
                        text-align: center;
                        font-size: 1.35rem;
                        font-weight: 800;
                        color: var(--text);
                        margin-bottom: 28px;
                        text-transform: uppercase;
                        letter-spacing: .4px;
                    }

                    /* ── CARD ── */
                    .card {
                        background: var(--white);
                        border: 1px solid #e5e7eb;
                        border-radius: 8px;
                        margin-bottom: 24px;
                        box-shadow: 0 4px 16px rgba(0, 0, 0, .05);
                    }

                    .card-header {
                        background: #b5000b;
                        color: #fff;
                        padding: 12px 22px;
                        font-weight: 700;
                        font-size: 1rem;
                        border-radius: 8px 8px 0 0;
                    }

                    .card-body {
                        padding: 26px 24px;
                    }

                    /* ── FORM LAYOUT ── */
                    .form-row {
                        display: flex;
                        gap: 16px;
                        flex-wrap: wrap;
                        margin-bottom: 16px;
                    }

                    .form-row .form-group {
                        flex: 1;
                        min-width: 220px;
                    }

                    .form-group {
                        margin-bottom: 16px;
                    }

                    .form-group:last-child {
                        margin-bottom: 0;
                    }

                    label.form-label {
                        display: block;
                        font-weight: 600;
                        font-size: .88rem;
                        color: var(--text);
                        margin-bottom: 6px;
                    }

                    label.form-label .req {
                        color: #b5000b;
                        margin-left: 2px;
                    }

                    .form-control {
                        display: block;
                        width: 100%;
                        padding: 8px 14px;
                        border: 1px solid #d1d5db;
                        border-radius: 6px;
                        font-size: .92rem;
                        font-family: inherit;
                        background: var(--white);
                        color: var(--text);
                        transition: border-color .15s, box-shadow .15s;
                        outline: none;
                        height: 42px;
                    }

                    textarea.form-control {
                        height: auto;
                        min-height: 120px;
                        resize: vertical;
                    }

                    select.form-control {
                        appearance: none;
                        cursor: pointer;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236c757d' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                        background-repeat: no-repeat;
                        background-position: right 12px center;
                        padding-right: 32px;
                    }

                    .form-control::placeholder {
                        color: #9ca3af;
                    }

                    .form-control:focus {
                        border-color: #b5000b;
                        box-shadow: 0 0 0 3px rgba(181, 0, 11, .12);
                    }

                    /* ── FILE UPLOAD ── */
                    .file-row {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        flex-wrap: wrap;
                    }

                    .btn-file-pick {
                        padding: 8px 18px;
                        background: var(--white);
                        border: 1px solid #d1d5db;
                        border-radius: 6px;
                        font-size: .88rem;
                        font-weight: 600;
                        color: var(--text);
                        cursor: pointer;
                        transition: all .15s;
                    }

                    .btn-file-pick:hover {
                        border-color: #b5000b;
                        color: #b5000b;
                        background: #fff0f3;
                    }

                    .file-label {
                        font-size: .85rem;
                        color: var(--muted);
                        font-style: italic;
                    }

                    /* ── SUBMIT BUTTON AREA ── */
                    .submit-row {
                        display: flex;
                        justify-content: flex-end;
                        margin-top: 20px;
                    }

                    .btn-submit {
                        padding: 12px 36px;
                        background: #b5000b;
                        color: #fff;
                        border: none;
                        border-radius: 6px;
                        font-size: 1rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: background .15s, opacity .15s;
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .btn-submit:hover {
                        background: #96001f;
                    }

                    .btn-submit:disabled {
                        opacity: .6;
                        cursor: not-allowed;
                    }

                    /* ── SUCCESS ── */
                    #successCard {
                        display: none;
                    }

                    .success-top {
                        background: linear-gradient(135deg, #b5000b, #e05a00);
                        padding: 32px 20px;
                        text-align: center;
                        color: #fff;
                        border-radius: 8px 8px 0 0;
                    }

                    .success-icon {
                        font-size: 3.2rem;
                        display: block;
                        margin-bottom: 10px;
                    }

                    .success-title {
                        font-size: 1.3rem;
                        font-weight: 800;
                    }

                    .success-body {
                        padding: 26px 24px;
                    }

                    .kv {
                        margin-bottom: 12px;
                        font-size: .95rem;
                    }

                    .code-badge {
                        display: inline-block;
                        padding: 4px 14px;
                        background: var(--red-light);
                        border: 1.5px dashed #e07088;
                        border-radius: 6px;
                        color: #b5000b;
                        font-weight: 800;
                        font-size: 1.05rem;
                    }

                    .hint {
                        color: var(--muted);
                        font-size: .85rem;
                        margin: 6px 0 18px;
                    }

                    .success-actions {
                        display: flex;
                        gap: 12px;
                        flex-wrap: wrap;
                        margin-top: 20px;
                    }

                    .btn-action {
                        padding: 10px 24px;
                        border-radius: 6px;
                        font-size: .9rem;
                        font-weight: 700;
                        cursor: pointer;
                        border: none;
                    }

                    .btn-action.primary {
                        background: #b5000b;
                        color: #fff;
                    }

                    .btn-action.secondary {
                        background: #495057;
                        color: #fff;
                    }

                    .btn-action:hover {
                        opacity: .88;
                    }

                    /* ── TRACUU ── */
                    .tracuu-row {
                        display: flex;
                        gap: 12px;
                    }

                    .tracuu-row input {
                        flex: 1;
                    }

                    .btn-tracuu {
                        padding: 8px 24px;
                        background: #b5000b;
                        color: #fff;
                        border: none;
                        border-radius: 6px;
                        font-weight: 700;
                        font-size: .92rem;
                        cursor: pointer;
                        white-space: nowrap;
                        transition: background .15s;
                    }

                    .btn-tracuu:hover {
                        background: #96001f;
                    }

                    /* ── TRACUU LIST (giống pakn.mattranso.vn) ── */
                    .search-bar {
                        display: flex;
                        gap: 12px;
                        flex-wrap: wrap;
                        margin-bottom: 24px;
                    }

                    .search-bar input {
                        flex: 1;
                        min-width: 220px;
                        height: 42px;
                    }

                    .btn-search {
                        padding: 0 28px;
                        height: 42px;
                        background: #b5000b;
                        color: #fff;
                        border: none;
                        border-radius: 6px;
                        font-weight: 700;
                        font-size: .92rem;
                        cursor: pointer;
                        white-space: nowrap;
                        transition: background .15s;
                    }

                    .btn-search:hover {
                        background: #96001f;
                    }

                    .fb-list {
                        list-style: none;
                        display: flex;
                        flex-direction: column;
                    }

                    .fb-item {
                        display: flex;
                        gap: 20px;
                        padding: 22px 0;
                        border-bottom: 1px solid #E9F0F8;
                        cursor: pointer;
                        transition: all .15s ease;
                        align-items: flex-start;
                    }

                    .fb-item:last-child {
                        border-bottom: none;
                    }

                    .fb-item:hover .fb-title {
                        color: #b5000b;
                    }

                    .fb-icon {
                        flex-shrink: 0;
                        width: 72px;
                        height: 72px;
                        border-radius: 50%;
                        background-color: rgba(234, 160, 49, 0.12);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.8rem;
                        margin-top: 2px;
                    }

                    .fb-body {
                        flex: 1;
                        min-width: 0;
                    }

                    .fb-meta {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        flex-wrap: wrap;
                        font-size: .88rem;
                        margin-bottom: 5px;
                    }

                    .fb-meta .sender {
                        font-weight: 600;
                        color: #374151;
                        text-transform: capitalize;
                    }

                    .fb-meta .time {
                        color: #9ca3af;
                    }

                    .fb-status {
                        font-size: .8rem;
                        font-weight: 600;
                        padding: 2px 10px;
                        border-radius: 12px;
                        margin-left: 4px;
                    }

                    .fb-status.answered {
                        color: #10b981;
                        background: #ecfdf5;
                    }

                    .fb-status.processing {
                        color: #f59e0b;
                        background: #fffbeb;
                    }

                    .fb-status.received {
                        color: #3b82f6;
                        background: #eff6ff;
                    }

                    .fb-title {
                        font-size: 1.1rem;
                        font-weight: 700;
                        color: #1f2937;
                        margin-bottom: 6px;
                        line-height: 1.45;
                        transition: color .15s;
                    }

                    .fb-excerpt {
                        font-size: .93rem;
                        color: #374151;
                        line-height: 1.55;
                        display: -webkit-box;
                        -webkit-line-clamp: 2;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                    }

                    .pagination-footer {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        flex-wrap: wrap;
                        gap: 12px;
                        margin-top: 24px;
                        padding-top: 16px;
                        border-top: 1px solid #f0f0f0;
                    }

                    .pagination-info {
                        font-size: .88rem;
                        color: var(--muted);
                    }

                    .pagination {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        margin-top: 0;
                    }

                    .pg-btn {
                        min-width: 36px;
                        height: 36px;
                        padding: 0 10px;
                        border: 1px solid #d1d5db;
                        border-radius: 6px;
                        background: var(--white);
                        font-size: .9rem;
                        font-weight: 600;
                        cursor: pointer;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        transition: all .15s;
                        color: #b5000b;
                    }

                    .pg-btn:hover {
                        border-color: #b5000b;
                        color: #a11826;
                        background: #fff0f3;
                    }

                    .pg-btn.active {
                        background: #b5000b;
                        color: #fff;
                        border-color: #b5000b;
                    }

                    .pg-btn:disabled {
                        opacity: .4;
                        cursor: not-allowed;
                    }

                    /* ── DETAIL PANEL (overlay) ── */
                    .detail-panel {
                        display: none;
                        position: fixed;
                        inset: 0;
                        background: rgba(0, 0, 0, .45);
                        z-index: 9999;
                        overflow-y: auto;
                    }

                    .detail-panel.show {
                        display: flex;
                        align-items: flex-start;
                        justify-content: center;
                        padding: 40px 16px;
                    }

                    .detail-box {
                        background: var(--white);
                        width: 100%;
                        max-width: 760px;
                        border-radius: var(--radius);
                        overflow: hidden;
                        box-shadow: 0 8px 40px rgba(0, 0, 0, .2);
                    }

                    .detail-head-bar {
                        background: var(--red);
                        color: #fff;
                        padding: 12px 18px;
                        font-weight: 700;
                        font-size: .95rem;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .btn-close-detail {
                        background: none;
                        border: none;
                        color: #fff;
                        font-size: 1.4rem;
                        cursor: pointer;
                        line-height: 1;
                        padding: 0 4px;
                    }

                    .detail-content {
                        padding: 28px 28px 32px;
                    }

                    .detail-category {
                        font-size: .82rem;
                        color: var(--muted);
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: .5px;
                        margin-bottom: 6px;
                    }

                    .detail-title {
                        font-size: 1.2rem;
                        font-weight: 800;
                        color: var(--text);
                        margin-bottom: 10px;
                    }

                    .detail-submeta {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        flex-wrap: wrap;
                        font-size: .83rem;
                        color: var(--muted);
                        margin-bottom: 6px;
                    }

                    .detail-submeta .sender {
                        font-weight: 700;
                        color: var(--text);
                    }

                    .detail-receiver {
                        font-size: .83rem;
                        color: var(--muted);
                        margin-bottom: 24px;
                    }

                    .detail-receiver strong {
                        color: var(--text);
                    }

                    .detail-section {
                        display: flex;
                        gap: 18px;
                        margin-bottom: 24px;
                    }

                    .ds-icon {
                        flex-shrink: 0;
                        width: 52px;
                        height: 52px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.5rem;
                    }

                    .ds-icon.content-icon {
                        background: #f5e6d0;
                    }

                    .ds-icon.reply-icon {
                        background: #e8f5e9;
                    }

                    .ds-body h4 {
                        font-size: 1rem;
                        font-weight: 700;
                        color: var(--text);
                        margin-bottom: 8px;
                    }

                    .ds-body p {
                        font-size: .9rem;
                        color: #444;
                        line-height: 1.7;
                    }

                    .ds-body p.pending {
                        color: var(--muted);
                        font-style: italic;
                    }

                    hr.detail-divider {
                        border: none;
                        border-top: 1px solid var(--border);
                        margin: 0 0 24px;
                    }

                    /* ── ADMIN MANAGE TAB ── */
                    .admin-toolbar {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        flex-wrap: wrap;
                        gap: 12px;
                        margin-bottom: 16px;
                    }

                    .filter-group {
                        display: flex;
                        gap: 8px;
                        flex-wrap: wrap;
                        align-items: center;
                    }

                    .filter-group label {
                        font-size: .82rem;
                        font-weight: 600;
                        color: var(--muted);
                    }

                    .filter-select {
                        padding: 6px 10px;
                        border: 1px solid var(--border);
                        border-radius: var(--radius);
                        font-size: .85rem;
                        font-family: inherit;
                        background: var(--white);
                        color: var(--text);
                    }

                    .btn-excel {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                        padding: 7px 16px;
                        background: #217346;
                        color: #fff;
                        border: none;
                        border-radius: var(--radius);
                        font-size: .88rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: background .15s;
                        white-space: nowrap;
                    }

                    .btn-excel:hover {
                        background: #1a5c38;
                    }

                    .btn-excel:disabled {
                        opacity: .55;
                        cursor: not-allowed;
                    }

                    .admin-table-wrap {
                        overflow-x: auto;
                    }

                    .admin-table {
                        width: 100%;
                        border-collapse: collapse;
                        font-size: .84rem;
                    }

                    .admin-table th {
                        background: #BB032A;
                        color: #fff;
                        padding: 9px 12px;
                        text-align: left;
                        font-weight: 700;
                        white-space: nowrap;
                    }

                    .admin-table td {
                        padding: 9px 12px;
                        border-bottom: 1px solid var(--border);
                        vertical-align: top;
                        line-height: 1.5;
                    }

                    .admin-table tr:hover td {
                        background: #fafafa;
                        cursor: pointer;
                    }

                    .admin-table .td-stt {
                        text-align: center;
                        width: 44px;
                        color: var(--muted);
                    }

                    .admin-table .td-status {
                        white-space: nowrap;
                    }

                    .admin-table .td-content {
                        max-width: 200px;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .admin-table .fs {
                        font-size: .78rem;
                        font-weight: 700;
                        padding: 2px 8px;
                        border-radius: 10px;
                    }

                    .admin-table .fs.answered {
                        color: #2b8a3e;
                        background: #dcfce7;
                    }

                    .admin-table .fs.processing {
                        color: #d97706;
                        background: #fef3c7;
                    }

                    .admin-table .fs.received {
                        color: #1d4ed8;
                        background: #dbeafe;
                    }

                    .admin-count {
                        font-size: .82rem;
                        color: var(--muted);
                    }

                    /* ── NAVBAR ADMIN BUTTONS ── */
                    .btn-nav-admin {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        gap: 8px;
                        background: rgba(255, 255, 255, .12);
                        border: 1px solid rgba(255, 255, 255, .85);
                        color: #fff;
                        padding: 9px 24px;
                        border-radius: 6px;
                        font-size: .95rem;
                        font-weight: 700;
                        cursor: pointer;
                        text-decoration: none;
                        transition: all .15s ease;
                        min-height: 42px;
                    }

                    .btn-nav-admin:hover {
                        background: #fff;
                        color: #b5000b;
                        border-color: #fff;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, .15);
                    }

                    .btn-nav-admin.logout {
                        background: rgba(220, 53, 69, .4);
                        border-color: rgba(255, 255, 255, .6);
                    }

                    .btn-nav-admin.logout:hover {
                        background: #dc3545;
                        color: #fff;
                    }

                    .navbar-right {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    /* ── VALIDATION ── */
                    .msg-error {
                        color: #dc3545;
                        font-size: .78rem;
                        margin-top: 4px;
                        display: none;
                    }

                    .field-error .msg-error {
                        display: block;
                    }

                    .field-error .form-control {
                        border-color: #dc3545;
                    }

                    /* ── FOOTER ── */

                    .site-footer {
                        background: var(--white);
                        border-top: 1px solid var(--border);
                        padding: 24px 20px;
                        margin-top: 40px;
                    }

                    .footer-inner {
                        max-width: 1320px;
                        margin: 0 auto;
                        display: flex;
                        justify-content: space-between;
                        flex-wrap: wrap;
                        gap: 16px;
                    }

                    .footer-left {
                        font-size: .82rem;
                        color: var(--muted);
                        line-height: 1.8;
                    }

                    .footer-right {
                        font-size: .82rem;
                        color: var(--muted);
                        line-height: 1.8;
                        text-align: right;
                    }

                    .footer-right a {
                        color: var(--red);
                        text-decoration: none;
                        font-weight: 600;
                    }

                    .footer-copy {
                        max-width: 1320px;
                        margin: 12px auto 0;
                        text-align: center;
                        font-size: .78rem;
                        color: #adb5bd;
                        border-top: 1px solid var(--border);
                        padding-top: 12px;
                    }

                    /* ── RESPONSIVE ── */
                    @media(max-width: 640px) {
                        .banner-text h1 {
                            font-size: 1rem;
                        }

                        .form-row {
                            flex-direction: column;
                        }

                        .submit-row {
                            justify-content: stretch;
                        }

                        .btn-submit {
                            width: 100%;
                            justify-content: center;
                        }

                        .footer-inner {
                            flex-direction: column;
                        }

                        .footer-right {
                            text-align: left;
                        }
                    }
                </style>
            </head>

            <body>

                <!-- ── HEADER BANNER ── -->
                <header>
                    <div class="site-banner">
                        <div class="banner-inner">
                            <div class="banner-logo">
                                <img src="<%= ctx %>/assets/logo.png" alt="Logo MTTQ"
                                    onerror="this.parentElement.textContent='🏛️'">
                            </div>
                            <div class="banner-text">
                                <h1>Ủy ban MTTQ Việt Nam Phường Liên Hòa</h1>
                                <p>Cổng tiếp nhận, xử lý phản ánh, kiến nghị của nhân dân</p>
                            </div>
                        </div>
                    </div>
                    <nav class="site-navbar">
                        <div class="navbar-inner">
                            <ul class="nav-links">
                                <li><a href="#" id="tab-gui" class="active" onclick="switchTab('gui');return false;">Gửi
                                        Phản ánh, Kiến nghị</a></li>
                                <li><a href="#" id="tab-tracuu" onclick="switchTab('tracuu');return false;">Tra cứu</a>
                                </li>
                                <li><a href="#" id="tab-van-ban" onclick="switchTab('van-ban');return false;">Văn bản, Thông báo</a>
                                </li>
                                <% if (isAdmin) { %>
                                    <li><a href="#" id="tab-quan-ly" onclick="switchTab('quan-ly');return false;">Quản
                                            lý</a></li>
                                    <% } %>
                            </ul>
                            <div class="navbar-right">
                                <% if (isAdmin) { %>
                                    <span class="btn-nav-admin" style="cursor:default;">👤 Admin</span>
                                    <button class="btn-nav-admin logout" onclick="doLogout()">Đăng xuất</button>
                                    <% } else { %>
                                        <a href="<%= ctx %>/phan-anh-login" class="btn-nav-admin">Đăng nhập</a>
                                        <% } %>
                            </div>
                        </div>
                    </nav>
                </header>

                <!-- ── MAIN ── -->
                <div class="page-wrap">
                    <h2 class="page-title">Hệ thống tiếp nhận, xử lý phản ánh, kiến nghị của người dân</h2>

                    <!-- FORM -->
                    <div id="formCard">

                        <!-- CARD 1: Khai báo thông tin -->
                        <div class="card">
                            <div class="card-header">Khai báo thông tin</div>
                            <div class="card-body">
                                <div class="form-row">
                                    <div class="form-group" id="fg-name">
                                        <label class="form-label">Họ và tên <span class="req">*</span></label>
                                        <input type="text" id="fbName" class="form-control"
                                            placeholder="Nhập họ và tên">
                                        <span class="msg-error">Vui lòng nhập họ và tên</span>
                                    </div>
                                    <div class="form-group" id="fg-phone">
                                        <label class="form-label">Số điện thoại <span class="req">*</span></label>
                                        <input type="tel" id="fbPhone" class="form-control"
                                            placeholder="Nhập số điện thoại">
                                        <span class="msg-error">Số điện thoại không hợp lệ</span>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Email</label>
                                        <input type="email" id="fbEmail" class="form-control" placeholder="Nhập email">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group" id="fg-thon">
                                        <label class="form-label">Địa bàn / Tổ dân phố <span
                                                class="req">*</span></label>
                                        <select id="fbThon" class="form-control">
                                            <option value="">Chọn địa bàn</option>
                                            <c:forEach var="entry" items="${districts}">
                                                <option value="${entry.key}">${entry.value.name}</option>
                                            </c:forEach>
                                        </select>
                                        <span class="msg-error">Vui lòng chọn địa bàn</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- CARD 2: Nội dung phản ánh -->
                        <div class="card">
                            <div class="card-header">Nội dung phản ánh</div>
                            <div class="card-body">
                                <div class="form-group" id="fg-type">
                                    <label class="form-label">Lĩnh vực phản ánh, kiến nghị <span
                                            class="req">*</span></label>
                                    <select id="fbType" class="form-control">
                                        <option value="">Chọn lĩnh vực</option>
                                        <c:forEach var="type" items="${feedbackTypes}">
                                            <option value="${type.code}">${type.name}</option>
                                        </c:forEach>
                                    </select>
                                    <span class="msg-error">Vui lòng chọn lĩnh vực</span>
                                </div>
                                <div class="form-group" id="fg-typeOther" style="display:none;">
                                    <label class="form-label">Lĩnh vực khác <span class="req">*</span></label>
                                    <input type="text" id="fbTypeOther" class="form-control"
                                        placeholder="Nhập tên lĩnh vực...">
                                    <span class="msg-error">Vui lòng nhập lĩnh vực</span>
                                </div>
                                <div class="form-group" id="fg-content">
                                    <label class="form-label">Nội dung chi tiết phản ánh <span
                                            class="req">*</span></label>
                                    <textarea id="fbContent" class="form-control" rows="6"
                                        placeholder="Nội dung chi tiết phản ánh"></textarea>
                                    <span class="msg-error">Vui lòng nhập nội dung</span>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Tệp đính kèm</label>
                                    <div class="file-row">
                                        <input type="file" id="fbFile" accept=".doc,.docx,.pdf,.png,.jpg,.jpeg"
                                            style="display:none">
                                        <button type="button" class="btn-file-pick"
                                            onclick="document.getElementById('fbFile').click()">
                                            Chọn tệp đính kèm
                                        </button>
                                        <span class="file-label" id="fileName">Chưa có tệp</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- SUBMIT -->
                        <div class="submit-row">
                            <button type="button" class="btn-submit" id="btnSubmit" onclick="submitFeedback()">
                                <span id="btnText">Gửi phản ánh</span>
                                <span id="btnSpinner" style="display:none">Đang gửi...</span>
                            </button>
                        </div>

                    </div><!-- /formCard -->

                    <!-- SUCCESS -->
                    <div class="card" id="successCard">
                        <div class="success-top">
                            <span class="success-icon">✅</span>
                            <div class="success-title">Phản ánh đã được tiếp nhận!</div>
                            <p style="font-size:.88rem;margin-top:6px;opacity:.85;">Chúng tôi sẽ xử lý trong vòng 3–5
                                ngày làm việc</p>
                        </div>
                        <div class="success-body">
                            <div class="kv">🎫 Mã hồ sơ: <span class="code-badge" id="successCode">—</span></div>
                            <p class="hint">Lưu mã này để tra cứu tiến độ xử lý phản ánh của bạn.</p>
                            <div class="kv">👤 Người gửi: <strong id="successName">—</strong></div>
                            <div class="kv">📞 Điện thoại: <strong id="successPhone">—</strong></div>
                            <div class="kv">📂 Lĩnh vực: <strong id="successType">—</strong></div>
                            <div class="success-actions">
                                <button onclick="resetForm()" class="btn-action primary">➕ Gửi phản ánh mới</button>
                                <button onclick="showTracuu()" class="btn-action secondary">🔍 Tra cứu hồ sơ</button>
                            </div>
                        </div>
                    </div>

                    <!-- TRACUU TAB (ẩn mặc định) -->
                    <div id="tracuuSection" style="display:none;">
                        <div class="card">
                            <div class="card-header">Danh sách phản ánh, kiến nghị</div>
                            <div class="card-body">
                                <!-- Thanh tìm kiếm -->
                                <div class="search-bar">
                                    <input type="text" id="tcSearch" class="form-control"
                                        placeholder="Nhập họ và tên cần tìm kiếm" style="max-width:320px;">
                                    <input type="text" id="tcCode" class="form-control"
                                        placeholder="Nhập mã hồ sơ cần tìm kiếm" style="max-width:260px;"
                                        onkeydown="if(event.key==='Enter') runSearch()">
                                    <button class="btn-search" onclick="runSearch()">Tìm kiếm</button>
                                </div>

                                <!-- Danh sách -->
                                <ul class="fb-list" id="fbList"></ul>

                                <!-- Hàng Phân trang & Thông tin -->
                                <div class="pagination-footer">
                                    <div id="tcInfo" class="pagination-info"></div>
                                    <div class="pagination" id="fbPager"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- DETAIL PANEL (popup overlay) -->
                    <div class="detail-panel" id="detailPanel">
                        <div class="detail-box">
                            <div class="detail-head-bar">
                                <span>Chi tiết Phản ánh, Kiến nghị</span>
                                <button class="btn-close-detail" onclick="closeDetail()">&times;</button>
                            </div>
                            <div class="detail-content" id="detailContent"></div>
                        </div>
                    </div>

                    <!-- VAN BAN & THONG BAO TAB (công khai) -->
                    <div id="vanbanSection" style="display:none;">
                        <div class="card" style="padding:24px;">
                            <div style="display:flex;gap:12px;flex-wrap:wrap;margin-bottom:20px;">
                                <input type="text" id="docSearch" class="form-control" style="flex:1;min-width:240px;" placeholder="Nhập từ khóa tiêu đề hoặc trích yếu văn bản..." onkeyup="runDocSearch()">
                                <select id="docCatFilter" class="form-control" style="width:220px;" onchange="runDocSearch()">
                                    <option value="">-- Tất cả loại văn bản --</option>
                                </select>
                            </div>

                            <ul class="fb-list" id="docList"></ul>

                            <div class="pagination-footer" style="margin-top:20px;">
                                <div id="docInfo" class="pagination-info"></div>
                                <div class="pagination" id="docPager"></div>
                            </div>
                        </div>
                    </div>

                    <!-- QUAN LY TAB (chỉ admin) -->
                    <% if (isAdmin) { %>
                        <div id="quanLySection" style="display:none;">
                            <div class="card">
                                <div class="card-header">Quản lý phản ánh, kiến nghị</div>
                                <div class="card-body">
                                    <div class="admin-toolbar">
                                        <div class="filter-group">
                                            <label>Lọc trạng thái:</label>
                                            <select class="filter-select" id="adminFilter"
                                                onchange="applyAdminFilter()">
                                                <option value="">Tất cả</option>
                                                <option value="received">Đã tiếp nhận</option>
                                                <option value="processing">Đang xử lý</option>
                                                <option value="answered">Đã trả lời</option>
                                            </select>
                                            <span class="admin-count" id="adminCount"></span>
                                        </div>
                                        <button class="btn-excel" id="btnExcel" onclick="exportExcel()">
                                             Xuất Excel
                                        </button>
                                    </div>
                                    <div class="admin-table-wrap">
                                        <table class="admin-table">
                                            <thead>
                                                <tr>
                                                    <th class="td-stt">STT</th>
                                                    <th>Mã hồ sơ</th>
                                                    <th>Họ và tên</th>
                                                    <th>SĐT</th>
                                                    <th>Địa bàn</th>
                                                    <th>Lĩnh vực</th>
                                                    <th>Nội dung</th>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày gửi</th>
                                                    <th style="width:90px;text-align:center;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody id="adminTbody"></tbody>
                                        </table>
                                    </div>
                                    <!-- Hàng Phân trang Admin & Thông tin -->
                                    <div class="pagination-footer">
                                        <div id="adminInfo" class="pagination-info"></div>
                                        <div class="pagination" id="adminPager"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quản lý Văn bản, Thông báo công khai cho Admin -->
                            <div class="card" style="margin-top:28px;">
                                <div class="card-header">
                                    <span>Quản lý Văn bản, Thông báo công khai</span>
                                </div>
                                <div class="card-body" style="padding:24px;">
                                    <form id="formAdminDoc" onsubmit="saveAdminDocument(event)" style="background:#f8f9fa;border:1px solid #e9ecef;border-radius:8px;padding:20px;margin-bottom:24px;">
                                        <h4 style="font-size:1rem;font-weight:700;color:#b5000b;margin-bottom:16px;">Đăng Văn bản / Thông báo mới</h4>
                                        <div class="form-row">
                                            <div class="form-group" style="flex:2;">
                                                <label class="form-label">Tiêu đề văn bản *</label>
                                                <input type="text" id="admDocTitle" class="form-control" placeholder="Nhập tiêu đề văn bản, báo cáo..." required>
                                            </div>
                                            <div class="form-group" style="flex:1;">
                                                <label class="form-label">Loại văn bản *</label>
                                                <select id="admDocCat" class="form-control" required></select>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Trích yếu / Mô tả ngắn nội dung văn bản</label>
                                            <textarea id="admDocDesc" class="form-control" rows="2" placeholder="Nhập tóm tắt trích yếu nội dung văn bản..."></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Chọn tệp văn bản đính kèm (PDF, DOCX, XLSX...) *</label>
                                            <input type="file" id="admDocFile" class="form-control" accept=".pdf,.doc,.docx,.xls,.xlsx,.png,.jpg,.jpeg" required>
                                        </div>
                                        <div style="margin-top:16px;">
                                            <button type="submit" class="btn-submit" id="btnSaveDoc" style="padding:10px 24px;font-size:.95rem;">
                                                Đăng văn bản công khai
                                            </button>
                                        </div>
                                    </form>

                                    <!-- Quản lý Thể loại Văn bản cho Admin -->
                                    <div style="background:#fff;border:1px solid #e9ecef;border-radius:8px;padding:20px;margin-bottom:24px;">
                                        <h4 style="font-size:1rem;font-weight:700;color:#212529;margin-bottom:12px;">Quản lý Thể loại Văn bản (Lưu trữ CSDL Railway)</h4>
                                        <div style="display:flex;gap:12px;margin-bottom:16px;max-width:650px;">
                                            <input type="text" id="newCatName" class="form-control" placeholder="Nhập tên thể loại mới (ví dụ: Quyết định, Chỉ thị, Nghị quyết...)...">
                                            <button type="button" class="btn-submit" onclick="addNewDocCategory()" style="padding:8px 20px;white-space:nowrap;background:#28a745;">+ Thêm thể loại</button>
                                        </div>
                                        <div id="catBadgeList" style="display:flex;gap:8px;flex-wrap:wrap;"></div>
                                    </div>

                                    <h4 style="font-size:1rem;font-weight:700;color:#212529;margin-bottom:16px;">Danh sách Văn bản đã đăng tải</h4>
                                    <div style="overflow-x:auto;">
                                        <table class="admin-table">
                                            <thead>
                                                <tr>
                                                    <th style="width:50px;">STT</th>
                                                    <th>Tiêu đề văn bản</th>
                                                    <th style="width:140px;">Loại</th>
                                                    <th style="width:120px;">Ngày đăng</th>
                                                    <th style="width:160px;">Tệp đính kèm</th>
                                                    <th style="width:100px;text-align:center;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody id="admDocTbody"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Đổi mật khẩu tài khoản Admin -->
                            <div class="card" style="margin-top:28px;">
                                <div class="card-header">
                                    <span>Đổi mật khẩu tài khoản Quản trị viên</span>
                                </div>
                                <div class="card-body" style="padding:24px;">
                                    <form id="formChangePass" onsubmit="changeAdminPassword(event)" style="background:#f8f9fa;border:1px solid #e9ecef;border-radius:8px;padding:20px;max-width:600px;">
                                        <div class="form-group">
                                            <label class="form-label">Mật khẩu hiện tại *</label>
                                            <input type="password" id="oldAdminPass" class="form-control" placeholder="Nhập mật khẩu hiện tại..." required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Mật khẩu mới *</label>
                                            <input type="password" id="newAdminPass" class="form-control" placeholder="Nhập mật khẩu mới..." required minlength="3">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Xác nhận mật khẩu mới *</label>
                                            <input type="password" id="confirmAdminPass" class="form-control" placeholder="Nhập lại mật khẩu mới..." required minlength="3">
                                        </div>
                                        <div style="margin-top:16px;">
                                            <button type="submit" class="btn-submit" id="btnChangePass" style="padding:10px 24px;font-size:.95rem;">
                                                Cập nhật mật khẩu mới
                                            </button>
                                        </div>
                                    </form>
                            <!-- CARD 4: Thử nghiệm kết nối Email -->
                            <div class="card" style="margin-top:20px;">
                                <div class="card-header">Thử nghiệm gửi Email thông báo</div>
                                <div class="card-body">
                                    <p style="font-size:0.9rem;color:#555;margin-bottom:12px;">Nhập địa chỉ email cá nhân để kiểm tra kết nối hệ thống gửi thông báo tự động:</p>
                                    <div style="display:flex;gap:10px;max-width:520px;">
                                        <input type="email" id="testEmailInput" class="form-control" placeholder="Nhập email của bạn (ví dụ: name@gmail.com)...">
                                        <button type="button" class="btn-submit" id="btnTestEmail" onclick="runTestEmail()" style="white-space:nowrap;padding:8px 18px;">
                                            Gửi Email thử
                                        </button>
                                    </div>
                                    <div id="testEmailResult" style="margin-top:12px;font-size:0.9rem;font-weight:600;"></div>
                                </div>
                            </div>
                        </div>
                        <% } %>

                </div><!-- /page-wrap -->

                <!-- ── FOOTER ── -->
                <footer class="site-footer">
                    <div class="footer-inner">
                        <div class="footer-left">
                            <div>Trung tâm CNTT & Truyền thông Ủy ban MTTQ Việt Nam Phường Liên Hòa Tỉnh Quảng Ninh</div>
                            <div>Ủy ban MTTQ Việt Nam Phường Liên Hòa, Tỉnh Quảng Ninh</div>
                        </div>
                        <div class="footer-right">
                            <div>Hỗ trợ kỹ thuật: CNTT Phường Liên Hòa</div>
                            <div>ĐT: 0328859888</div>
                        </div>
                    </div>
                    <div class="footer-copy">Bản quyền thuộc về Ủy ban MTTQ Việt Nam Phường Liên Hòa © 2025</div>
                </footer>

                <script>
                    (function () {
                        'use strict';
                        var BASE = '<%= ctx %>';
                        var IS_ADMIN = <%= isAdmin %>;

                        /* File input */
                        document.getElementById('fbFile').addEventListener('change', function () {
                            var f = this.files[0];
                            document.getElementById('fileName').textContent = f ? f.name : 'Chưa có tệp';
                        });

                        /* Toggle "Lĩnh vực khác" */
                        document.getElementById('fbType').addEventListener('change', function () {
                            var sel = this.options[this.selectedIndex];
                            var isOther = sel && sel.text.trim() === 'Lĩnh vực khác';
                            var otherGroup = document.getElementById('fg-typeOther');
                            otherGroup.style.display = isOther ? 'block' : 'none';
                            document.getElementById('fbTypeOther').required = isOther;
                            if (!isOther) document.getElementById('fbTypeOther').value = '';
                        });

                        /* Validation */
                        function validate() {
                            var ok = true;
                            function check(groupId, value, extraCheck) {
                                var g = document.getElementById(groupId);
                                if (!g) return;
                                var pass = value && value.trim() !== '' && (!extraCheck || extraCheck(value));
                                g.classList.toggle('field-error', !pass);
                                if (!pass) ok = false;
                            }
                            check('fg-name', document.getElementById('fbName').value);
                            check('fg-phone', document.getElementById('fbPhone').value, function (v) { return /^[0-9+\s\-]{8,15}$/.test(v.trim()); });
                            check('fg-thon', document.getElementById('fbThon').value);
                            check('fg-type', document.getElementById('fbType').value);
                            check('fg-content', document.getElementById('fbContent').value);
                            if (document.getElementById('fg-typeOther').style.display !== 'none') {
                                check('fg-typeOther', document.getElementById('fbTypeOther').value);
                            }
                            return ok;
                        }

                        /* Submit */
                        window.submitFeedback = function () {
                            if (!validate()) {
                                document.querySelector('.field-error').scrollIntoView({ behavior: 'smooth', block: 'center' });
                                return;
                            }
                            var btn = document.getElementById('btnSubmit');
                            btn.disabled = true;
                            document.getElementById('btnText').style.display = 'none';
                            document.getElementById('btnSpinner').style.display = 'inline';

                            var name = document.getElementById('fbName').value.trim();
                            var phone = document.getElementById('fbPhone').value.trim();
                            var email = document.getElementById('fbEmail') ? document.getElementById('fbEmail').value.trim() : '';
                            var thon = document.getElementById('fbThon').value;
                            var type = document.getElementById('fbType').value;
                            var content = document.getElementById('fbContent').value.trim();
                            var fg = document.getElementById('fg-typeOther');
                            var typeOther = fg.style.display !== 'none' ? document.getElementById('fbTypeOther').value.trim() : '';
                            var typeName = document.getElementById('fbType').options[document.getElementById('fbType').selectedIndex].text;

                            var formData = new FormData();
                            formData.append('name', name);
                            formData.append('phone', phone);
                            if (email) formData.append('email', email);
                            formData.append('thon', thon);
                            formData.append('type', type);
                            formData.append('content', content);
                            if (typeOther) formData.append('typeOther', typeOther);

                            var fileInput = document.getElementById('fbFile');
                            if (fileInput && fileInput.files && fileInput.files[0]) {
                                formData.append('file', fileInput.files[0]);
                            }

                            fetch(BASE + '/api/feedback', {
                                method: 'POST',
                                body: formData
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        var code = 'PA-' + new Date().getFullYear() + '-' + String(res.id).padStart(3, '0');
                                        document.getElementById('successCode').textContent = code;
                                        document.getElementById('successName').textContent = name;
                                        document.getElementById('successPhone').textContent = phone;
                                        document.getElementById('successType').textContent = typeOther || typeName;
                                        document.getElementById('formCard').style.display = 'none';
                                        document.getElementById('successCard').style.display = 'block';
                                        document.getElementById('successCard').scrollIntoView({ behavior: 'smooth' });
                                        allFeedbacks = [];
                                        loadFeedbackList(true);
                                    } else {
                                        alert('Gửi thất bại: ' + (res.message || 'Lỗi không xác định'));
                                    }
                                })
                                .catch(function () { alert('Lỗi kết nối máy chủ. Vui lòng thử lại!'); })
                                .finally(function () {
                                    btn.disabled = false;
                                    document.getElementById('btnText').style.display = 'inline';
                                    document.getElementById('btnSpinner').style.display = 'none';
                                });
                        };

                        /* Reset */
                        window.resetForm = function () {
                            ['fbName', 'fbPhone', 'fbEmail', 'fbThon', 'fbType', 'fbContent', 'fbTypeOther'].forEach(function (id) {
                                var el = document.getElementById(id);
                                if (el) el.value = '';
                            });
                            document.getElementById('fg-typeOther').style.display = 'none';
                            document.getElementById('fileName').textContent = 'Chưa có tệp';
                            document.querySelectorAll('.field-error').forEach(function (el) { el.classList.remove('field-error'); });
                            document.getElementById('successCard').style.display = 'none';
                            document.getElementById('formCard').style.display = 'block';
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        };

                        /* ── FEEDBACK LIST & DETAIL ── */

                        var allFeedbacks = [];   // dữ liệu gốc từ API
                        var filteredList = [];   // sau khi lọc tìm kiếm
                        
                        function processFeedbackData(rawList) {
                            if (!rawList) return [];
                            return rawList.map(function (fb) {
                                var displayType = fb.type || 'Phản ánh, kiến nghị';
                                var displayContent = fb.content || '';
                                if (displayContent) {
                                    var match = displayContent.match(/^\[Lĩnh vực:\s*([^\]]+)\]\s*(.*)/s);
                                    if (match) {
                                        displayType = match[1].trim();
                                        displayContent = match[2].trim();
                                    }
                                }
                                return {
                                    id: fb.id,
                                    voterName: fb.voterName,
                                    phone: fb.phone,
                                    date: fb.date,
                                    thon: fb.thon,
                                    type: displayType,
                                    content: displayContent,
                                    originalContent: fb.content,
                                    status: fb.status,
                                    statusLabel: fb.statusLabel,
                                    reply: fb.reply,
                                    attachedFile: fb.attachedFile
                                };
                            });
                        }

                        var PAGE_SIZE = 12;
                        var currentPage = 1;

                        /* Load toàn bộ dữ liệu khi chuyển sang tab Tra cứu */
                        function loadFeedbackList(forceRefresh) {
                            if (!forceRefresh && allFeedbacks.length > 0) {
                                runSearch();
                                return;
                            }
                            fetch(BASE + '/api/feedback')
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    allFeedbacks = data.sort(function (a, b) { return b.id - a.id; });
                                    runSearch();
                                })
                                .catch(function () {
                                    document.getElementById('fbList').innerHTML =
                                        '<li style="padding:20px;color:#dc3545;text-align:center;">Lỗi tải dữ liệu. Vui lòng thử lại.</li>';
                                });
                        }

                        /* Tìm kiếm */
                        window.runSearch = function () {
                            var name = (document.getElementById('tcSearch').value || '').trim().toLowerCase();
                            var code = (document.getElementById('tcCode').value || '').trim().toUpperCase();
                            filteredList = allFeedbacks.filter(function (fb) {
                                var matchName = !name || fb.voterName.toLowerCase().indexOf(name) !== -1;
                                var fbCode = 'PA-' + new Date().getFullYear() + '-' + String(fb.id).padStart(3, '0');
                                var matchCode = !code || fbCode.indexOf(code) !== -1 || String(fb.id).indexOf(code) !== -1;
                                return matchName && matchCode;
                            });
                            currentPage = 1;
                            renderList();
                        };

                        /* Render danh sách */
                        function renderList() {
                            var ul = document.getElementById('fbList');
                            var info = document.getElementById('tcInfo');
                            var total = filteredList.length;
                            var totalPages = Math.ceil(total / PAGE_SIZE) || 1;
                            if (currentPage > totalPages) currentPage = totalPages;

                            var start = (currentPage - 1) * PAGE_SIZE;
                            var page = filteredList.slice(start, start + PAGE_SIZE);

                            info.textContent = 'Hiển thị ' + (start + 1) + ' đến ' + (start + page.length) + ' của ' + total + ' kết quả';

                            ul.innerHTML = '';
                            if (!page.length) {
                                ul.innerHTML = '<li style="padding:24px;color:var(--muted);text-align:center;">Không tìm thấy kết quả nào.</li>';
                                renderPager(totalPages);
                                return;
                            }

                            page.forEach(function (fb) {
                                var statusTxt = fb.status === 'answered' ? 'Đã trả lời' : (fb.status === 'processing' ? 'Đang xử lý' : 'Đã tiếp nhận');
                                var statusCls = fb.status === 'answered' ? 'answered' : (fb.status === 'processing' ? 'processing' : 'received');
                                var excerpt = fb.content ? fb.content : '';
                                var code = 'PA-' + new Date().getFullYear() + '-' + String(fb.id).padStart(3, '0');

                                var li = document.createElement('li');
                                li.className = 'fb-item';
                                li.onclick = function () { openDetail(fb.id); };
                                li.innerHTML =
                                    '<div class="fb-icon"><img src="' + BASE + '/assets/icon.svg" alt="icon" style="width:28px;height:32px;"></div>' +
                                    '<div class="fb-body">' +
                                    '<div class="fb-meta">' +
                                    '<span class="sender">' + fb.voterName + '</span>' +
                                    '<span class="time">- ' + (fb.date || '') + '</span>' +
                                    '<span class="fb-status ' + statusCls + '">' + statusTxt + '</span>' +
                                    '</div>' +
                                    '<div class="fb-title">' + (fb.type || 'Phản ánh, kiến nghị') + '</div>' +
                                    '<div class="fb-excerpt"><strong>Nội dung kiến nghị:</strong> ' + excerpt + '</div>' +
                                    '</div>';
                                ul.appendChild(li);
                            });

                            renderPager(totalPages);
                        }

                        /* Phân trang */
                        function renderPager(totalPages) {
                            var pager = document.getElementById('fbPager');
                            pager.innerHTML = '';
                            if (totalPages <= 1) return;

                            function mkBtn(label, page, disabled, active) {
                                var b = document.createElement('button');
                                b.className = 'pg-btn' + (active ? ' active' : '');
                                b.textContent = label;
                                b.disabled = disabled;
                                if (!disabled) b.onclick = function () { currentPage = page; renderList(); };
                                return b;
                            }

                            pager.appendChild(mkBtn('‹', currentPage - 1, currentPage === 1, false));

                            var pages = [];
                            if (totalPages <= 7) {
                                for (var i = 1; i <= totalPages; i++) pages.push(i);
                            } else {
                                pages = [1, 2];
                                if (currentPage > 4) pages.push('...');
                                for (var j = Math.max(3, currentPage - 1); j <= Math.min(totalPages - 2, currentPage + 1); j++) pages.push(j);
                                if (currentPage < totalPages - 3) pages.push('...');
                                pages.push(totalPages - 1); pages.push(totalPages);
                            }

                            pages.forEach(function (p) {
                                if (p === '...') {
                                    var s = document.createElement('span');
                                    s.className = 'pg-btn'; s.textContent = '...'; s.disabled = true;
                                    pager.appendChild(s);
                                } else {
                                    pager.appendChild(mkBtn(p, p, false, p === currentPage));
                                }
                            });

                            pager.appendChild(mkBtn('›', currentPage + 1, currentPage === totalPages, false));
                        }

                        /* Mở chi tiết */
                        window.openDetail = function (id) {
                            var fb = allFeedbacks.find(function (f) { return f.id === id; });
                            if (!fb) return;

                            var code = 'PA-' + new Date().getFullYear() + '-' + String(fb.id).padStart(3, '0');
                            var statusTxt = fb.status === 'answered' ? 'Đã trả lời'
                                : (fb.status === 'processing' ? 'Đang xử lý' : 'Đã tiếp nhận');
                            var statusCls = fb.status === 'answered' ? 'answered'
                                : (fb.status === 'processing' ? 'processing' : 'received');

                            var replySection = fb.status === 'answered' && fb.reply
                                ? '<div class="ds-body"><h4>Cơ quan chức năng trả lời:</h4><p>' + fb.reply + '</p></div>'
                                : '<div class="ds-body"><h4>Cơ quan chức năng trả lời:</h4><p class="pending">Yếu cầu đang được xem xét và xử lý theo quy định.</p></div>';

                            var attachedSection = '';
                            if (IS_ADMIN && fb.attachedFile && fb.attachedFile.trim() !== '') {
                                var fileUrl = BASE + '/uploads/' + encodeURIComponent(fb.attachedFile);
                                attachedSection =
                                    '<div class="detail-section">' +
                                    '<div class="ds-icon content-icon">📎</div>' +
                                    '<div class="ds-body"><h4>Tệp đính kèm:</h4><p><a href="' + fileUrl + '" target="_blank" download style="color:#b5000b;font-weight:700;text-decoration:underline;">📥 Xem / Tải về tệp: ' + fb.attachedFile + '</a></p></div>' +
                                    '</div>';
                            }

                            var adminFormSection = '';
                            if (IS_ADMIN) {
                                var rSelReceived = fb.status === 'received' ? 'selected' : '';
                                var rSelProcessing = fb.status === 'processing' ? 'selected' : '';
                                var rSelAnswered = fb.status === 'answered' ? 'selected' : '';
                                var curReply = fb.reply || '';

                                adminFormSection =
                                    '<hr class="detail-divider">' +
                                    '<div style="background:#f8f9fa;border:1px solid #e9ecef;border-radius:8px;padding:16px 20px;margin-top:16px;">' +
                                    '<h4 style="font-size:1rem;font-weight:700;color:#b5000b;margin-bottom:12px;">⚙️ Quản lý: Cập nhật Trạng thái & Phản hồi</h4>' +
                                    '<div style="margin-bottom:12px;">' +
                                    '<label style="display:block;font-weight:600;font-size:.85rem;margin-bottom:4px;">Trạng thái xử lý:</label>' +
                                    '<select id="admStatusSelect" class="form-control" style="max-width:260px;">' +
                                    '<option value="received" ' + rSelReceived + '>Đã tiếp nhận</option>' +
                                    '<option value="processing" ' + rSelProcessing + '>Đang xử lý</option>' +
                                    '<option value="answered" ' + rSelAnswered + '>Đã trả lời</option>' +
                                    '</select>' +
                                    '</div>' +
                                    '<div style="margin-bottom:14px;">' +
                                    '<label style="display:block;font-weight:600;font-size:.85rem;margin-bottom:4px;">Nội dung trả lời / Chỉ đạo:</label>' +
                                    '<textarea id="admReplyContent" class="form-control" rows="4" placeholder="Nhập nội dung trả lời gửi người dân...">' + curReply + '</textarea>' +
                                    '</div>' +
                                    '<div>' +
                                    '<button type="button" class="btn-submit" id="btnSaveReply" onclick="saveAdminReply(' + fb.id + ')" style="padding:8px 24px;font-size:.9rem;">' +
                                    '💾 Lưu phản hồi & Cập nhật' +
                                    '</button>' +
                                    '</div>' +
                                    '</div>';
                            }

                            document.getElementById('detailContent').innerHTML =
                                '<div class="detail-title">Phản ánh, kiến nghị: ' + fb.type + '</div>' +
                                '<div class="detail-submeta">' +
                                '<span class="sender">' + fb.voterName + (fb.email ? (' (' + fb.email + ')') : '') + '</span>' +
                                '<span>&bull;</span>' +
                                '<span>' + (fb.date || '') + '</span>' +
                                '<span>&bull;</span>' +
                                '<span class="fb-status ' + statusCls + '">' + statusTxt + '</span>' +
                                '</div>' +
                                '<div class="detail-receiver">Khu vực: <strong>' + fb.thon + '</strong></div>' +
                                '<hr class="detail-divider">' +
                                '<div class="detail-section">' +
                                '<div class="ds-icon content-icon" style="background:transparent;"><img src="' + BASE + '/assets/mess.svg" alt="mess" style="width:52px;height:52px;"></div>' +
                                '<div class="ds-body"><h4>Nội dung:</h4><p>' + fb.content + '</p></div>' +
                                '</div>' +
                                attachedSection +
                                '<div class="detail-section">' +
                                '<div class="ds-icon reply-icon" style="background:transparent;"><img src="' + BASE + '/assets/icon-answer.svg" alt="answer" style="width:52px;height:52px;"></div>' +
                                replySection +
                                '</div>' +
                                adminFormSection;

                            var panel = document.getElementById('detailPanel');
                            panel.classList.add('show');
                            document.body.style.overflow = 'hidden';
                        };

                        /* Lưu phản hồi từ Admin */
                        window.saveAdminReply = function (id) {
                            var statusSelect = document.getElementById('admStatusSelect');
                            var replyContent = document.getElementById('admReplyContent');
                            if (!statusSelect || !replyContent) return;

                            var status = statusSelect.value;
                            var reply = replyContent.value.trim();

                            var btn = document.getElementById('btnSaveReply');
                            if (btn) btn.disabled = true;

                            var params = new URLSearchParams();
                            params.append('action', 'update');
                            params.append('id', String(id));
                            params.append('status', status);
                            params.append('reply', reply);

                            fetch(BASE + '/api/feedback', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        alert('Cập nhật phản hồi thành công!');
                                        var item = allFeedbacks.find(function (f) { return f.id === id; });
                                        if (item) {
                                            item.status = status;
                                            item.statusLabel = status === 'answered' ? 'Đã trả lời' : (status === 'processing' ? 'Đang xử lý' : 'Đã tiếp nhận');
                                            item.reply = reply;
                                        }
                                        renderList();
                                        loadAdminTable(true);
                                        openDetail(id);
                                    } else {
                                        alert('Cập nhật thất bại: ' + (res.message || 'Lỗi không xác định'));
                                    }
                                })
                                .catch(function (err) {
                                    console.error(err);
                                    alert('Lỗi kết nối máy chủ!');
                                })
                                .finally(function () {
                                    if (btn) btn.disabled = false;
                                });
                        };

                        window.closeDetail = function () {
                            document.getElementById('detailPanel').classList.remove('show');
                            document.body.style.overflow = '';
                        };

                        /* Đóng khi click ra ngoài detail-box */
                        document.getElementById('detailPanel').addEventListener('click', function (e) {
                            if (e.target === this) window.closeDetail();
                        });
                        /* Đóng khi nhấn Escape */
                        document.addEventListener('keydown', function (e) {
                            if (e.key === 'Escape') window.closeDetail();
                        });

                        /* ── TAB SWITCHING ── */
                        window.switchTab = function (tab) {
                            var formCard = document.getElementById('formCard');
                            var successCard = document.getElementById('successCard');
                            var tracuuSec = document.getElementById('tracuuSection');
                            var vanbanSec = document.getElementById('vanbanSection');
                            var quanLySec = document.getElementById('quanLySection');
                            var pageTitle = document.querySelector('.page-title');

                            // Ẩn tất cả sections
                            if (formCard) formCard.style.display = 'none';
                            if (successCard) successCard.style.display = 'none';
                            if (tracuuSec) tracuuSec.style.display = 'none';
                            if (vanbanSec) vanbanSec.style.display = 'none';
                            if (quanLySec) quanLySec.style.display = 'none';

                            // Xóa active trên tất cả tab links
                            ['tab-gui', 'tab-tracuu', 'tab-van-ban', 'tab-quan-ly'].forEach(function (id) {
                                var el = document.getElementById(id);
                                if (el) el.classList.remove('active');
                            });

                            if (tab === 'tracuu') {
                                if (tracuuSec) tracuuSec.style.display = 'block';
                                if (pageTitle) pageTitle.textContent = 'Tra cứu kết quả';
                                var tEl = document.getElementById('tab-tracuu');
                                if (tEl) tEl.classList.add('active');
                                loadFeedbackList(true);
                            } else if (tab === 'van-ban') {
                                if (vanbanSec) vanbanSec.style.display = 'block';
                                if (pageTitle) pageTitle.textContent = 'Văn bản, Thông báo, Báo cáo công khai';
                                var vEl = document.getElementById('tab-van-ban');
                                if (vEl) vEl.classList.add('active');
                                loadDocumentList(true);
                            } else if (tab === 'quan-ly') {
                                if (quanLySec) quanLySec.style.display = 'block';
                                if (pageTitle) pageTitle.textContent = 'Quản lý phản ánh, kiến nghị';
                                var qEl = document.getElementById('tab-quan-ly');
                                if (qEl) qEl.classList.add('active');
                                loadAdminTable(true);
                                loadDocumentList(true);
                            } else {
                                // tab 'gui' (mặc định)
                                if (formCard) formCard.style.display = 'block';
                                if (pageTitle) pageTitle.textContent = 'Hệ thống tiếp nhận, xử lý phản ánh, kiến nghị của người dân';
                                var gEl = document.getElementById('tab-gui');
                                if (gEl) gEl.classList.add('active');
                            }

                            if (window.history && window.history.pushState) {
                                window.history.pushState(null, '', '#' + tab);
                            }
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        };

                        window.showTracuu = function () {
                            var code = document.getElementById('successCode').textContent;
                            if (code && code !== '—') {
                                document.getElementById('tcCode').value = code;
                            }
                            switchTab('tracuu');
                        };

                        /* ── ADMIN TABLE ── */
                        var adminData = [];
                        var adminFiltered = [];
                        var ADMIN_PAGE_SIZE = 20;
                        var adminCurrentPage = 1;

                        function loadAdminTable(forceRefresh) {
                            if (!forceRefresh && allFeedbacks.length > 0) {
                                adminData = allFeedbacks.slice();
                                adminFiltered = adminData.slice();
                                adminCurrentPage = 1;
                                renderAdminTable();
                                return;
                            }
                            fetch(BASE + '/api/feedback')
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    allFeedbacks = processFeedbackData(data).sort(function (a, b) { return b.id - a.id; });
                                    adminData = allFeedbacks.slice();
                                    adminFiltered = adminData.slice();
                                    adminCurrentPage = 1;
                                    renderAdminTable();
                                })
                                .catch(function () {
                                    document.getElementById('adminTbody').innerHTML =
                                        '<tr><td colspan="9" style="text-align:center;color:#dc3545;padding:20px;">Lỗi tải dữ liệu!</td></tr>';
                                });
                        }

                        window.applyAdminFilter = function () {
                            var status = document.getElementById('adminFilter').value;
                            adminFiltered = status
                                ? adminData.filter(function (fb) { return fb.status === status; })
                                : adminData.slice();
                            adminCurrentPage = 1;
                            renderAdminTable();
                        };

                        function renderAdminTable() {
                            var tbody = document.getElementById('adminTbody');
                            var count = document.getElementById('adminCount');
                            var info = document.getElementById('adminInfo');
                            var total = adminFiltered.length;
                            var totalPages = Math.ceil(total / ADMIN_PAGE_SIZE) || 1;
                            if (adminCurrentPage > totalPages) adminCurrentPage = totalPages;

                            if (count) count.textContent = '(' + total + ' phản ánh)';

                            if (!total) {
                                tbody.innerHTML = '<tr><td colspan="10" style="text-align:center;color:var(--muted);padding:20px;">Không có dữ liệu.</td></tr>';
                                if (info) info.textContent = 'Hiển thị 0 kết quả';
                                renderAdminPager(totalPages);
                                return;
                            }

                            var start = (adminCurrentPage - 1) * ADMIN_PAGE_SIZE;
                            var pageData = adminFiltered.slice(start, start + ADMIN_PAGE_SIZE);

                            if (info) {
                                info.textContent = 'Hiển thị ' + (start + 1) + ' đến ' + (start + pageData.length) + ' của ' + total + ' phản ánh';
                            }

                            var html = '';
                            pageData.forEach(function (fb, idx) {
                                var i = start + idx;
                                var code = 'PA-' + new Date().getFullYear() + '-' + String(fb.id).padStart(3, '0');
                                var statusCls = fb.status === 'answered' ? 'answered' : (fb.status === 'processing' ? 'processing' : 'received');
                                var statusTxt = fb.status === 'answered' ? 'Đã trả lời' : (fb.status === 'processing' ? 'Đang xử lý' : 'Đã tiếp nhận');
                                var excerpt = fb.content ? (fb.content.length > 60 ? fb.content.substring(0, 60) + '...' : fb.content) : '';
                                html +=
                                    '<tr onclick="openDetail(' + fb.id + ')" title="Click để xem chi tiết">' +
                                    '<td class="td-stt">' + (i + 1) + '</td>' +
                                    '<td><strong>' + code + '</strong></td>' +
                                    '<td>' + fb.voterName + '</td>' +
                                    '<td>' + (fb.phone || '') + '</td>' +
                                    '<td>' + (fb.thon || '') + '</td>' +
                                    '<td>' + (fb.type || '') + '</td>' +
                                    '<td class="td-content">' + excerpt + '</td>' +
                                    '<td class="td-status"><span class="fs ' + statusCls + '">' + statusTxt + '</span></td>' +
                                    '<td>' + (fb.date || '') + '</td>' +
                                    '<td style="text-align:center;" onclick="event.stopPropagation()">' +
                                    '<button type="button" class="btn-submit" style="background:#dc3545;padding:4px 10px;font-size:.82rem;" onclick="deleteFeedback(' + fb.id + ')">Xóa</button>' +
                                    '</td>' +
                                    '</tr>';
                            });
                            tbody.innerHTML = html;
                            renderAdminPager(totalPages);
                        }

                        window.deleteFeedback = function (id) {
                            if (!confirm('Bạn có chắc chắn muốn xóa phản ánh này khỏi hệ thống?')) return;
                            fetch(BASE + '/api/feedback?id=' + id, { method: 'DELETE' })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        alert('Xóa phản ánh thành công!');
                                        location.reload();
                                    } else {
                                        alert('Lỗi xóa phản ánh: ' + (res.message || 'Lỗi không xác định'));
                                    }
                                })
                                .catch(function () {
                                    alert('Lỗi kết nối máy chủ!');
                                });
                        };

                        function renderAdminPager(totalPages) {
                            var pager = document.getElementById('adminPager');
                            if (!pager) return;
                            pager.innerHTML = '';
                            if (totalPages <= 1) return;

                            function mkBtn(label, page, disabled, active) {
                                var b = document.createElement('button');
                                b.className = 'pg-btn' + (active ? ' active' : '');
                                b.textContent = label;
                                b.disabled = disabled;
                                if (!disabled) b.onclick = function () { adminCurrentPage = page; renderAdminTable(); };
                                return b;
                            }

                            pager.appendChild(mkBtn('‹', adminCurrentPage - 1, adminCurrentPage === 1, false));

                            var pages = [];
                            if (totalPages <= 7) {
                                for (var i = 1; i <= totalPages; i++) pages.push(i);
                            } else {
                                pages = [1, 2];
                                if (adminCurrentPage > 4) pages.push('...');
                                for (var j = Math.max(3, adminCurrentPage - 1); j <= Math.min(totalPages - 2, adminCurrentPage + 1); j++) pages.push(j);
                                if (adminCurrentPage < totalPages - 3) pages.push('...');
                                pages.push(totalPages - 1); pages.push(totalPages);
                            }

                            pages.forEach(function (p) {
                                if (p === '...') {
                                    var s = document.createElement('span');
                                    s.className = 'pg-btn'; s.textContent = '...'; s.disabled = true;
                                    pager.appendChild(s);
                                } else {
                                    pager.appendChild(mkBtn(p, p, false, p === adminCurrentPage));
                                }
                            });

                            pager.appendChild(mkBtn('›', adminCurrentPage + 1, adminCurrentPage === totalPages, false));
                        }

                        /* ── XUẤT EXCEL (dùng ExcelJS giống AI_Task_Dispatcher) ── */
                        window.exportExcel = async function () {
                            if (!adminFiltered.length) {
                                alert('Không có dữ liệu để xuất!');
                                return;
                            }

                            var btn = document.getElementById('btnExcel');
                            btn.disabled = true;
                            btn.textContent = 'Đang tạo file...';

                            try {
                                if (typeof ExcelJS === 'undefined') {
                                    alert('Không tải được thư viện ExcelJS. Vui lòng kiểm tra kết nối mạng!');
                                    return;
                                }

                                var workbook = new ExcelJS.Workbook();
                                var worksheet = workbook.addWorksheet('Danh sách phản ánh');

                                // Cấu hình cột
                                worksheet.columns = [
                                    { header: 'STT', key: 'stt', width: 6 },
                                    { header: 'Mã hồ sơ', key: 'code', width: 16 },
                                    { header: 'Họ và tên', key: 'name', width: 24 },
                                    { header: 'SĐT', key: 'phone', width: 14 },
                                    { header: 'Địa bàn', key: 'thon', width: 22 },
                                    { header: 'Lĩnh vực', key: 'type', width: 24 },
                                    { header: 'Nội dung', key: 'content', width: 45 },
                                    { header: 'Trạng thái', key: 'status', width: 16 },
                                    { header: 'Phản hồi', key: 'reply', width: 35 },
                                    { header: 'Ngày gửi', key: 'date', width: 14 }
                                ];

                                // Style header row
                                var headerRow = worksheet.getRow(1);
                                headerRow.height = 28;
                                headerRow.font = { name: 'Times New Roman', size: 11, bold: true };
                                headerRow.alignment = { vertical: 'middle', horizontal: 'center', wrapText: true };
                                headerRow.eachCell(function (cell) {
                                    cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFBB032A' } };
                                    cell.font = { name: 'Times New Roman', size: 11, bold: true, color: { argb: 'FFFFFFFF' } };
                                    cell.border = {
                                        top: { style: 'thin', color: { argb: 'FF7F8C8D' } },
                                        left: { style: 'thin', color: { argb: 'FF7F8C8D' } },
                                        bottom: { style: 'thin', color: { argb: 'FF7F8C8D' } },
                                        right: { style: 'thin', color: { argb: 'FF7F8C8D' } }
                                    };
                                });

                                // Đổ dữ liệu
                                adminFiltered.forEach(function (fb, i) {
                                    var code = 'PA-' + new Date().getFullYear() + '-' + String(fb.id).padStart(3, '0');
                                    var statusTxt = fb.status === 'answered' ? 'Đã trả lời'
                                        : (fb.status === 'processing' ? 'Đang xử lý' : 'Đã tiếp nhận');
                                    var row = worksheet.addRow([
                                        i + 1, code, fb.voterName || '', fb.phone || '',
                                        fb.thon || '', fb.type || '', fb.content || '',
                                        statusTxt, fb.reply || '', fb.date || ''
                                    ]);
                                    row.font = { name: 'Times New Roman', size: 11 };
                                    row.alignment = { vertical: 'top', wrapText: true };
                                    row.getCell(1).alignment = { horizontal: 'center', vertical: 'top' };

                                    // Màu trạng thái
                                    var statusColor = fb.status === 'answered' ? 'FF166534'
                                        : (fb.status === 'processing' ? 'FF92400E' : 'FF1D4ED8');
                                    row.getCell(8).font = { name: 'Times New Roman', size: 11, bold: true, color: { argb: statusColor } };

                                    // Viền
                                    for (var c = 1; c <= 10; c++) {
                                        row.getCell(c).border = {
                                            top: { style: 'thin', color: { argb: 'FFA1A1A1' } },
                                            left: { style: 'thin', color: { argb: 'FFA1A1A1' } },
                                            bottom: { style: 'thin', color: { argb: 'FFA1A1A1' } },
                                            right: { style: 'thin', color: { argb: 'FFA1A1A1' } }
                                        };
                                    }
                                });

                                // Tạo buffer và download
                                var buffer = await workbook.xlsx.writeBuffer();
                                var blob = new Blob([buffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
                                var url = URL.createObjectURL(blob);
                                var today = new Date().toISOString().slice(0, 10);
                                var link = document.createElement('a');
                                link.href = url;
                                link.download = 'PhanAnh_MTTQ_LienHoa_' + today + '.xlsx';
                                link.style.visibility = 'hidden';
                                document.body.appendChild(link);
                                link.click();
                                document.body.removeChild(link);
                                URL.revokeObjectURL(url);

                            } catch (err) {
                                console.error('Lỗi xuất Excel:', err);
                                alert('Có lỗi xảy ra khi tạo file Excel: ' + err.message);
                            } finally {
                                btn.disabled = false;
                                btn.innerHTML = 'Xuất Excel';
                            }
                        };

                        /* ── VĂN BẢN, THÔNG BÁO ── */
                        var allDocs = [];
                        var filteredDocs = [];
                        var DOC_PAGE_SIZE = 10;
                        var docCurrentPage = 1;

                        function loadDocumentList(forceRefresh) {
                            if (!forceRefresh && allDocs.length > 0) {
                                runDocSearch();
                                renderAdminDocTable();
                                return;
                            }
                            fetch(BASE + '/api/documents')
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    allDocs = data.sort(function (a, b) { return b.id - a.id; });
                                    runDocSearch();
                                    renderAdminDocTable();
                                })
                                .catch(function () {
                                    var ul = document.getElementById('docList');
                                    if (ul) ul.innerHTML = '<li style="padding:20px;color:#dc3545;text-align:center;">Lỗi tải danh sách văn bản. Vui lòng thử lại.</li>';
                                });
                        }

                        window.runDocSearch = function () {
                            var kw = (document.getElementById('docSearch').value || '').trim().toLowerCase();
                            var cat = (document.getElementById('docCatFilter').value || '').trim();
                            filteredDocs = allDocs.filter(function (doc) {
                                var matchKw = !kw || doc.title.toLowerCase().indexOf(kw) !== -1 || (doc.description && doc.description.toLowerCase().indexOf(kw) !== -1);
                                var matchCat = !cat || doc.category === cat;
                                return matchKw && matchCat;
                            });
                            docCurrentPage = 1;
                            renderDocList();
                        };

                        window.openDocViewer = function(id, filePath) {
                            var ext = (filePath || '').split('.').pop().toLowerCase();
                            var rawUrl = BASE + '/api/documents?id=' + id + '&mode=view';
                            var fullRawUrl = window.location.origin + rawUrl;

                            if (ext === 'pdf' || ext === 'png' || ext === 'jpg' || ext === 'jpeg' || ext === 'txt') {
                                window.open(rawUrl, '_blank');
                            } else if (ext === 'doc' || ext === 'docx' || ext === 'xls' || ext === 'xlsx' || ext === 'ppt' || ext === 'pptx') {
                                var googleViewer = 'https://docs.google.com/viewer?url=' + encodeURIComponent(fullRawUrl);
                                window.open(googleViewer, '_blank');
                            } else {
                                window.open(rawUrl, '_blank');
                            }
                        };

                        function renderDocList() {
                            var ul = document.getElementById('docList');
                            var info = document.getElementById('docInfo');
                            if (!ul) return;

                            var total = filteredDocs.length;
                            var totalPages = Math.ceil(total / DOC_PAGE_SIZE) || 1;
                            if (docCurrentPage > totalPages) docCurrentPage = totalPages;

                            var start = (docCurrentPage - 1) * DOC_PAGE_SIZE;
                            var page = filteredDocs.slice(start, start + DOC_PAGE_SIZE);

                            if (info) info.textContent = 'Hiển thị ' + (start + 1) + ' đến ' + (start + page.length) + ' của ' + total + ' văn bản';

                            ul.innerHTML = '';
                            if (!page.length) {
                                ul.innerHTML = '<li style="padding:24px;color:var(--muted);text-align:center;">Không tìm thấy văn bản nào.</li>';
                                renderDocPager(totalPages);
                                return;
                            }

                            page.forEach(function (doc) {
                                var downloadUrl = BASE + '/api/documents?id=' + doc.id + '&mode=download';
                                var safeFilePath = (doc.filePath || '').replace(/'/g, "\\'");
                                var li = document.createElement('li');
                                li.className = 'fb-item';
                                li.style.cursor = 'default';
                                li.innerHTML =
                                    '<div class="fb-icon" style="background:#eef2ff;color:#4f46e5;font-size:1.8rem;display:flex;align-items:center;justify-content:center;width:48px;height:48px;border-radius:8px;">📄</div>' +
                                    '<div class="fb-body" style="flex:1;">' +
                                    '<div class="fb-meta">' +
                                    '<span class="fb-status processing" style="background:#e0e7ff;color:#3730a3;font-weight:700;">' + doc.category + '</span>' +
                                    '<span class="time">- Ngày ban hành: ' + (doc.docDate || '') + '</span>' +
                                    '</div>' +
                                    '<div style="display:flex;justify-content:space-between;align-items:flex-start;gap:16px;margin:6px 0 4px;">' +
                                    '<a href="#" onclick="openDocViewer(' + doc.id + ', \'' + safeFilePath + '\');return false;" style="font-size:1.05rem;font-weight:700;color:#b5000b;text-decoration:none;line-height:1.35;" onmouseover="this.style.textDecoration=\'underline\'" onmouseout="this.style.textDecoration=\'none\'">' + doc.title + '</a>' +
                                    '<a href="' + downloadUrl + '" target="_blank" download style="display:inline-block;padding:6px 18px;background:#b5000b;color:#fff;border-radius:4px;font-weight:700;font-size:.85rem;text-decoration:none;white-space:nowrap;flex-shrink:0;">Tải về</a>' +
                                    '</div>' +
                                    '<div class="fb-excerpt">' + (doc.description ? ('<strong>Trích yếu:</strong> ' + doc.description) : '') + '</div>' +
                                    '</div>';
                                ul.appendChild(li);
                            });

                            renderDocPager(totalPages);
                        }

                        function renderDocPager(totalPages) {
                            var pager = document.getElementById('docPager');
                            if (!pager) return;
                            pager.innerHTML = '';
                            if (totalPages <= 1) return;

                            function mkBtn(label, page, disabled, active) {
                                var b = document.createElement('button');
                                b.className = 'pg-btn' + (active ? ' active' : '');
                                b.textContent = label;
                                b.disabled = disabled;
                                if (!disabled) b.onclick = function () { docCurrentPage = page; renderDocList(); };
                                return b;
                            }

                            pager.appendChild(mkBtn('‹', docCurrentPage - 1, docCurrentPage === 1, false));
                            for (var i = 1; i <= totalPages; i++) {
                                pager.appendChild(mkBtn(i, i, false, i === docCurrentPage));
                            }
                            pager.appendChild(mkBtn('›', docCurrentPage + 1, docCurrentPage === totalPages, false));
                        }

                        window.saveAdminDocument = function (e) {
                            if (e) e.preventDefault();
                            var title = document.getElementById('admDocTitle').value.trim();
                            var category = document.getElementById('admDocCat').value;
                            var description = document.getElementById('admDocDesc').value.trim();
                            var fileInput = document.getElementById('admDocFile');

                            if (!title || !category || !fileInput.files[0]) {
                                alert('Vui lòng điền tiêu đề, chọn loại văn bản và chọn tệp đính kèm!');
                                return;
                            }

                            var btn = document.getElementById('btnSaveDoc');
                            if (btn) { btn.disabled = true; btn.textContent = 'Đang đăng văn bản...'; }

                            var formData = new FormData();
                            formData.append('title', title);
                            formData.append('category', category);
                            formData.append('description', description);
                            formData.append('file', fileInput.files[0]);

                            fetch(BASE + '/api/documents', {
                                method: 'POST',
                                body: formData
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        alert('Đăng văn bản thành công!');
                                        document.getElementById('formAdminDoc').reset();
                                        loadDocumentList(true);
                                    } else {
                                        alert('Lỗi đăng văn bản: ' + (res.message || 'Lỗi không xác định'));
                                    }
                                })
                                .catch(function (err) {
                                    console.error(err);
                                    alert('Lỗi kết nối máy chủ!');
                                })
                                .finally(function () {
                                    if (btn) { btn.disabled = false; btn.textContent = 'Đăng văn bản công khai'; }
                                });
                        };

                        function renderAdminDocTable() {
                            var tbody = document.getElementById('admDocTbody');
                            if (!tbody) return;

                            if (!allDocs.length) {
                                tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--muted);padding:20px;">Chưa có văn bản nào.</td></tr>';
                                return;
                            }

                            var html = '';
                            allDocs.forEach(function (doc, idx) {
                                var downloadUrl = BASE + '/api/documents?id=' + doc.id + '&mode=download';
                                var safeFilePath = (doc.filePath || '').replace(/'/g, "\\'");
                                html +=
                                    '<tr>' +
                                    '<td>' + (idx + 1) + '</td>' +
                                    '<td><a href="#" onclick="openDocViewer(' + doc.id + ', \'' + safeFilePath + '\');return false;" style="color:#b5000b;font-weight:700;text-decoration:none;" onmouseover="this.style.textDecoration=\'underline\'" onmouseout="this.style.textDecoration=\'none\'">' + doc.title + '</a><br><small style="color:var(--muted);">' + (doc.description || '') + '</small></td>' +
                                    '<td><span class="fb-status processing" style="background:#e0e7ff;color:#3730a3;font-weight:700;">' + doc.category + '</span></td>' +
                                    '<td>' + (doc.docDate || '') + '</td>' +
                                    '<td><a href="' + downloadUrl + '" target="_blank" download style="color:#4b5563;font-weight:700;text-decoration:underline;">Tải về</a></td>' +
                                    '<td style="text-align:center;">' +
                                    '<button type="button" class="btn-submit" style="background:#dc3545;padding:4px 10px;font-size:.82rem;" onclick="deleteAdminDoc(' + doc.id + ')">Xóa</button>' +
                                    '</td>' +
                                    '</tr>';
                            });
                            tbody.innerHTML = html;
                        }

                        window.deleteAdminDoc = function (id) {
                            if (!confirm('Bạn có chắc chắn muốn xóa văn bản này khỏi danh sách công khai?')) return;
                            fetch(BASE + '/api/documents?id=' + id, { method: 'DELETE' })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        alert('Xóa văn bản thành công!');
                                        location.reload();
                                    } else {
                                        alert('Lỗi xóa văn bản: ' + (res.message || 'Lỗi không xác định'));
                                    }
                                })
                                .catch(function () {
                                    alert('Lỗi kết nối máy chủ!');
                                });
                        };

                        window.changeAdminPassword = function (e) {
                            e.preventDefault();
                            var oldPass = document.getElementById('oldAdminPass').value;
                            var newPass = document.getElementById('newAdminPass').value;
                            var confirmPass = document.getElementById('confirmAdminPass').value;

                            if (!oldPass || !newPass || !confirmPass) {
                                alert('Vui lòng điền đầy đủ các thông tin!');
                                return;
                            }

                            if (newPass !== confirmPass) {
                                alert('Mật khẩu mới và mật khẩu xác nhận không trùng khớp!');
                                return;
                            }

                            var btn = document.getElementById('btnChangePass');
                            if (btn) { btn.disabled = true; btn.textContent = 'Đang xử lý...'; }

                            var params = new URLSearchParams();
                            params.append('action', 'changePassword');
                            params.append('oldPassword', oldPass);
                            params.append('newPassword', newPass);

                            fetch(BASE + '/api/auth', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                                body: params.toString()
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        alert('Đổi mật khẩu quản trị viên thành công! Vui lòng ghi nhớ mật khẩu mới.');
                                        document.getElementById('formChangePass').reset();
                                    } else {
                                        alert('Lỗi: ' + (res.message || 'Không thể đổi mật khẩu'));
                                    }
                                })
                                .catch(function (err) {
                                    console.error(err);
                                    alert('Lỗi kết nối máy chủ!');
                                })
                                .finally(function () {
                                    if (btn) { btn.disabled = false; btn.textContent = 'Cập nhật mật khẩu mới'; }
                                });
                        };

                        /* ── ĐĂNG XUẤT ── */
                        window.doLogout = function () {
                            var params = new URLSearchParams();
                            params.append('action', 'logout');
                            fetch(BASE + '/api/auth', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            })
                                .then(function () { window.location.href = BASE + '/phan-anh'; })
                                .catch(function () { window.location.href = BASE + '/phan-anh'; });
                        };

                        /* ── THỬ NGHIỆM GỬI EMAIL ── */
                        window.runTestEmail = function () {
                            var emailInput = document.getElementById('testEmailInput');
                            var resDiv = document.getElementById('testEmailResult');
                            var btn = document.getElementById('btnTestEmail');

                            if (!emailInput || !emailInput.value.trim()) {
                                alert('Vui lòng nhập địa chỉ Email để thử nghiệm!');
                                return;
                            }
                            btn.disabled = true;
                            resDiv.style.color = '#312e81';
                            resDiv.textContent = '⏳ Đang kết nối tới máy chủ Gmail SMTP...';

                            var params = new URLSearchParams();
                            params.append('email', emailInput.value.trim());

                            fetch(BASE + '/api/test-email', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                                body: params.toString()
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        resDiv.style.color = '#15803d';
                                        resDiv.textContent = res.message;
                                    } else {
                                        resDiv.style.color = '#b91c1c';
                                        resDiv.textContent = res.message;
                                    }
                                })
                                .catch(function () {
                                    resDiv.style.color = '#b91c1c';
                                    resDiv.textContent = '❌ Lỗi kết nối máy chủ!';
                                })
                                .finally(function () {
                                    btn.disabled = false;
                                });
                        };

                        /* ── QUẢN LÝ THỂ LOẠI VĂN BẢN (RAILWAY CSDL) ── */
                        var allDocCategories = [];

                        function loadDocumentCategories() {
                            fetch(BASE + '/api/document-categories')
                                .then(function (r) { return r.json(); })
                                .then(function (list) {
                                    allDocCategories = list || [];
                                    updateDocCatSelects();
                                })
                                .catch(function (e) {
                                    console.error('Lỗi tải thể loại văn bản:', e);
                                });
                        }

                        function updateDocCatSelects() {
                            var filterSel = document.getElementById('docCatFilter');
                            var admSel = document.getElementById('admDocCat');

                            if (filterSel) {
                                var currentVal = filterSel.value;
                                filterSel.innerHTML = '<option value="">-- Tất cả loại văn bản --</option>';
                                allDocCategories.forEach(function (cat) {
                                    var opt = document.createElement('option');
                                    opt.value = cat;
                                    opt.textContent = cat;
                                    filterSel.appendChild(opt);
                                });
                                filterSel.value = currentVal;
                            }

                            if (admSel) {
                                var currentVal = admSel.value;
                                admSel.innerHTML = '';
                                allDocCategories.forEach(function (cat) {
                                    var opt = document.createElement('option');
                                    opt.value = cat;
                                    opt.textContent = cat;
                                    admSel.appendChild(opt);
                                });
                                if (currentVal) admSel.value = currentVal;
                            }

                            var badgeDiv = document.getElementById('catBadgeList');
                            if (badgeDiv) {
                                badgeDiv.innerHTML = '';
                                allDocCategories.forEach(function (cat) {
                                    var span = document.createElement('span');
                                    span.style.cssText = 'background:#e0e7ff;color:#3730a3;font-weight:700;padding:6px 14px;border-radius:20px;display:inline-flex;align-items:center;gap:8px;font-size:.88rem;';
                                    span.innerHTML = cat + ' <a href="#" onclick="deleteDocCategory(\'' + cat.replace(/'/g, "\\'") + '\');return false;" style="color:#dc3545;text-decoration:none;font-weight:bold;margin-left:4px;" title="Xóa thể loại này">&times;</a>';
                                    badgeDiv.appendChild(span);
                                });
                            }
                        }

                        window.addNewDocCategory = function () {
                            var input = document.getElementById('newCatName');
                            if (!input || !input.value.trim()) {
                                alert('Vui lòng nhập tên thể loại văn bản mới!');
                                return;
                            }
                            var name = input.value.trim();
                            var params = new URLSearchParams();
                            params.append('name', name);

                            fetch(BASE + '/api/document-categories', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                                body: params.toString()
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        alert(res.message);
                                        input.value = '';
                                        loadDocumentCategories();
                                    } else {
                                        alert('Lỗi: ' + (res.message || 'Không thể thêm thể loại'));
                                    }
                                })
                                .catch(function () { alert('Lỗi kết nối máy chủ!'); });
                        };

                        window.deleteDocCategory = function (name) {
                            if (!confirm('Bạn có chắc chắn muốn xóa thể loại "' + name + '"?')) return;
                            fetch(BASE + '/api/document-categories?name=' + encodeURIComponent(name), { method: 'DELETE' })
                                .then(function (r) { return r.json(); })
                                .then(function (res) {
                                    if (res.success) {
                                        alert(res.message);
                                        loadDocumentCategories();
                                    } else {
                                        alert('Lỗi: ' + (res.message || 'Không thể xóa thể loại'));
                                    }
                                })
                                .catch(function () { alert('Lỗi kết nối máy chủ!'); });
                        };

                        /* Auto-detect tab từ URL & Load Thể loại */
                        (function initTab() {
                            loadDocumentCategories();
                            var hash = window.location.hash;
                            if (hash === '#tracuu') { switchTab('tracuu'); return; }
                            if (hash === '#van-ban') { switchTab('van-ban'); return; }
                            if (hash === '#quan-ly') { switchTab('quan-ly'); return; }
                            var search = window.location.search;
                            if (search.indexOf('tracuu') !== -1) {
                                switchTab('tracuu');
                                var urlCode = new URLSearchParams(search).get('ma');
                                if (urlCode) {
                                    document.getElementById('tcCode').value = urlCode.toUpperCase();
                                    window.runSearch();
                                }
                            }
                        })();

                        window.addEventListener('popstate', function () {
                            var h = window.location.hash;
                            if (h === '#tracuu') { switchTab('tracuu'); return; }
                            if (h === '#van-ban') { switchTab('van-ban'); return; }
                            if (h === '#quan-ly') { switchTab('quan-ly'); return; }
                            switchTab('gui');
                        });
                    })();
                </script>
            </body>

            </html>
