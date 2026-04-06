// =========================================================================
/**
 * @name Stremio-Addon-Manager
 * @description Enhanced UI for managing, reordering, and backing up addons.
 * @updateUrl https://raw.githubusercontent.com/Sul-404/Stremio-Addon-Manager/main/addon-manager.1.1.0.plugin.js
 * @version 1.1.0
 * @author Sul-404
 */
// =========================================================================
(function () {
    'use strict';
    const CONFIG = {
        ids: {
            style: 'addon-manager-styles',
            wrapper: 'am-wrapper',
            toggleBtn: 'am-header-toggle',
            backupBtn: 'am-header-backup'
        },
        classes: {
            container: 'am-container',
            overlay: 'am-overlay-wrapper',
            row: 'am-addon-row',
            dragging: 'dragging',
            over: 'over'
        },
        api: {
            collectionSet: 'https://api.strem.io/api/addonCollectionSet'
        },
        selectors: {
            stremioContainer: '[class*="addons-list-container"]',
            stremioHeaderInputs: '[class*="selectable-inputs-container"]',
            stremioHeaderSpacing: '[class*="spacing"]'
        }
    };

    // -- State Management -----------------------------------------------------
    let state = {
        addons: [],
        dragSource: null
    };

    // -- Localization ---------------------------------------------------------
    const ICONS = {
        pencil: '<svg viewBox="0 0 24 24"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path></svg>',
        puzzle: '<svg viewBox="0 0 576 512" fill="currentColor"><path d="M345.1 480H274c-2.36.01-4.71-.45-6.89-1.36s-4.16-2.25-5.81-3.94A18 18 0 0 1 256 462v-27.7c.03-4.26-.82-8.49-2.5-12.4a32.3 32.3 0 0 0-7.19-10.4c-7.81-7.6-19.11-11.81-30.91-11.5-21.4.49-39.4 19.3-39.4 41.1V462c.01 2.36-.45 4.71-1.36 6.89s-2.25 4.16-3.94 5.81A18.07 18.07 0 0 1 158 480H87.6a55.67 55.67 0 0 1-39.36-16.26 55.64 55.64 0 0 1-16.34-39.35V354a18.1 18.1 0 0 1 5.29-12.7c3.38-3.38 7.94-5.27 12.71-5.3h27.7c9.2 0 18.1-3.9 25.1-11 3.9-3.92 7-8.58 9.1-13.7a40.7 40.7 0 0 0 3.1-16.2c-.3-21.2-17.7-39.1-38.11-39.1H50c-2.36.01-4.71-.45-6.9-1.36-2.17-.91-4.15-2.25-5.81-3.94A18 18 0 0 1 32 238v-70.4a55.8 55.8 0 0 1 4.2-21.3 53.7 53.7 0 0 1 12.1-18A55.7 55.7 0 0 1 87.6 112h55.2c2.13.01 4.18-.81 5.7-2.31.73-.74 1.33-1.63 1.72-2.62.4-.97.6-2.02.58-3.07v-6.5a64.7 64.7 0 0 1 5.1-25.3 66.6 66.6 0 0 1 14.5-21.4c6.21-6.11 13.6-10.9 21.7-14.1 8.08-3.2 16.71-4.8 25.4-4.7 35.5.6 64.4 30.4 64.4 66.3v5.7c-.03 1.59.42 3.16 1.3 4.47a7.77 7.77 0 0 0 3.62 2.96c.98.39 2.04.59 3.08.57h55.2c7.22-.01 14.35 1.42 21 4.2a54.96 54.96 0 0 1 29.7 29.7 54.3 54.3 0 0 1 4.2 21v55.19c-.03 1.6.42 3.17 1.31 4.49a7.73 7.73 0 0 0 3.61 2.95c.98.39 2.04.59 3.08.57h5.7c36.6 0 66.31 29 66.31 64.6 0 36.6-29.41 66.4-65.51 66.4H408c-2.13-.01-4.16.82-5.7 2.3a7.9 7.9 0 0 0-1.71 2.62 7.6 7.6 0 0 0-.59 3.08v56c.01 7.2-1.42 14.35-4.2 21a54.96 54.96 0 0 1-29.7 29.7 53.9 53.9 0 0 1-21 4.2"></path></svg>',
        check: '<svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>',
        share: '<svg viewBox="0 0 24 24"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>',
        copy: '<svg viewBox="0 0 24 24"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>',
        config: '<svg viewBox="0 0 24 24"><path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path></svg>',
        reinstall: '<svg viewBox="0 0 24 24"><path d="M23 4v6h-6"></path><path d="M1 20v-6h6"></path><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>',
        delete: '<svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>',
        upload: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>',
        download: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>'
    };

    const TRANSLATIONS = {
        'en': {
            'addon_manager': 'Addon Manager',
            'edit_addons': 'Edit Addons',
            'done': 'Done',
            'sync_changes': 'Sync Changes',
            'syncing': 'Syncing...',
            'backup_restore': 'Backup & Restore',
            'backup_manager': 'Backup & Restore',
            'manage_config': 'Manage your addon configuration',
            'export': 'Export',
            'export_desc': 'Save your current addons to a JSON file.',
            'import': 'Import',
            'import_desc': 'Restore addons from a backup file.',
            'cancel': 'Cancel',
            'confirm': 'Confirm',
            'confirm_backup': 'Confirm Backup',
            'confirm_backup_msg': 'Download backup of your installed addons?',
            'backup_success': 'Addons downloaded successfully.',
            'error': 'Error',
            'backup_failed': 'Failed to create backup.',
            'export_success': 'Export Success',
            'export_success_msg': 'Addons exported successfully.',
            'export_failed': 'Failed to export addons.',
            'confirm_import': 'Confirm Import',
            'confirm_import_msg': 'Replace current addons with {count} addons from backup?',
            'import_error': 'Import Error',
            'import_error_msg': 'Invalid or corrupt JSON file.',
            'success': 'Success!',
            'sync_success_msg': 'Synced successfully!',
            'sync_failed': 'Sync Failed',
            'saved_locally': 'Saved Locally',
            'login_to_sync': 'Please login to sync changes.',
            'uninstall': 'Uninstall',
            'system_addon': 'System Addon (Cannot Remove)',
            'ok': 'OK',
            'unknown': 'Unknown',
            'uninstall_confirm': 'Uninstall {name}?',
            'share': 'Open',
            'copy': 'Copy Link',
            'reinstall': 'Update & Reinstall',
            'configure': 'Configure',
            'open_url_confirm': 'Open External Link',
            'open_url_msg': 'Open {url} in your browser?',
            'sync_error_console': 'Sync error (check console)',
            'unknown_error': 'Unknown error'
        },
        'ar': {
            'addon_manager': 'إدارة الإضافات',
            'edit_addons': 'تعديل الإضافات',
            'done': 'تم',
            'sync_changes': 'مزامنة',
            'syncing': 'جاري المزامنة...',
            'backup_restore': 'نسخ احتياطي و استعادة',
            'backup_manager': 'النسخ الاحتياطي والاستعادة',
            'manage_config': 'إدارة تكوين الإضافات الخاصة بك',
            'export': 'تصدير',
            'export_desc': 'حفظ الإضافات الحالية في ملف JSON.',
            'import': 'استيراد',
            'import_desc': 'استعادة الإضافات من ملف نسخ احتياطي.',
            'cancel': 'إلغاء',
            'confirm': 'تأكيد',
            'confirm_backup': 'تأكيد النسخ الاحتياطي',
            'confirm_backup_msg': 'هل تريد تنزيل نسخة احتياطية من إضافاتك؟',
            'backup_success': 'تم تنزيل إضافاتك بنجاح.',
            'error': 'خطأ',
            'backup_failed': 'فشل إنشاء النسخة الاحتياطية.',
            'export_success': 'نجاح التصدير',
            'export_success_msg': 'تم تصدير الإضافات بنجاح.',
            'export_failed': 'فشل تصدير الإضافات.',
            'confirm_import': 'تأكيد الاستيراد',
            'confirm_import_msg': 'استبدال الإضافات الحالية بـ {count} إضافة من النسخة الاحتياطية؟',
            'import_error': 'خطأ في الاستيراد',
            'import_error_msg': 'ملف JSON غير صالح.',
            'success': 'تمت المزامنة!',
            'sync_success_msg': 'تمت المزامنة بنجاح!',
            'sync_failed': 'فشل المزامنة',
            'saved_locally': 'تم الحفظ محليًا',
            'login_to_sync': 'يرجى تسجيل الدخول للمزامنة.',
            'uninstall': 'إلغاء التثبيت',
            'system_addon': 'إضافة نظام (لا يمكن إزالتها)',
            'ok': 'موافق',
            'unknown': 'غير معروف',
            'uninstall_confirm': 'إلغاء تثبيت {name}؟',
            'share': 'فتح',
            'copy': 'نسخ الرابط',
            'reinstall': 'تحديث & إعادة التثبيت',
            'configure': 'الإعدادات',
            'open_url_confirm': 'فتح رابط خارجي',
            'open_url_msg': 'فتح {url} في المتصفح؟',
            'sync_error_console': 'خطأ في المزامنة (تحقق من الكونسول)',
            'unknown_error': 'خطأ غير معروف'
        }
    };

    // -- Utilities ------------------------------------------------------------
    function getLanguage() {
        try {
            const settings = JSON.parse(localStorage.getItem('settings') || '{}');
            if (settings.interfaceLanguage) return settings.interfaceLanguage;
            if (settings.language) return settings.language;

            const profile = JSON.parse(localStorage.getItem('profile') || '{}');
            if (profile.settings && profile.settings.interfaceLanguage) return profile.settings.interfaceLanguage;

            const navLang = navigator.language || navigator.userLanguage;
            if (navLang) return navLang.split('-')[0];
        } catch (e) { console.error('[AddonManager] Lang detection error', e); }
        return 'en';
    }

    function t(key, vars = {}) {
        let lang = getLanguage();
        lang = lang.includes('-') ? lang.split('-')[0] : lang;
        const dict = TRANSLATIONS[lang] || TRANSLATIONS['en'];
        let text = dict[key] || TRANSLATIONS['en'][key] || key;

        for (const [k, v] of Object.entries(vars)) {
            text = text.replace(new RegExp(`\\{${k}\\}`, 'g'), v);
        }
        return text;
    }

    // -- Styles ---------------------------------------------------------------
    function injectStyles() {
        if (document.getElementById(CONFIG.ids.style)) return;

        const style = document.createElement('style');
        style.id = CONFIG.ids.style;
        style.textContent = `
            :root {
                --am-bg: var(--overlay-color, #16161c);
                --am-fg: var(--primary-foreground-color, #ffffff);
                --am-accent: #7B67EB;
                --am-border-radius: var(--border-radius, 6px);
            }

            /* Overlay Wrapper */
            .${CONFIG.classes.overlay} {
                position: relative;
                width: 100%;
                min-height: 100%;
                background: transparent;
                z-index: 100;
                padding-top: 1rem;
            }

            /* Hide Native List when Active */
            div[class*="addons-list-container"]:has(#${CONFIG.ids.wrapper}) > *:not(#${CONFIG.ids.wrapper}) {
                display: none !important;
            }

            /* Container */
            .${CONFIG.classes.container} { 
                display: flex; flex-direction: column; gap: 1.5rem; 
                width: 100%; padding: 0 0.5rem;
            }

            /* Addon Card */
            .${CONFIG.classes.row} { 
                display: flex; flex-direction: row; align-items: flex-start; 
                background: var(--am-bg); 
                padding: 1.5rem; 
                border-radius: var(--am-border-radius); 
                transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s;
                user-select: none; cursor: grab; position: relative; z-index: 1;
                border: 0.15rem solid transparent;
                min-height: 11rem;
            }
            .${CONFIG.classes.row}:hover { 
                border-color: rgba(255,255,255,0.05);
                transform: translateY(-1px);
                z-index: 2; 
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }
            .${CONFIG.classes.row}.${CONFIG.classes.dragging} { 
                opacity: 0.5; border: 1px dashed #cccccc; 
                background: rgba(60,60,60,0.5); z-index: 10; 
            }
            .${CONFIG.classes.row}.${CONFIG.classes.over} { 
                border: 1px solid var(--am-accent); 
                transform: scale(1.01); 
                background: rgba(50, 60, 80, 0.8); 
            }

            /* Card Content */
            .am-logo-container { flex: none; width: 8rem; height: 8rem; margin-right: 1.5rem; }
            .am-addon-icon { display: block; width: 100%; height: 100%; object-fit: contain; padding: 0.5rem; }
            
            .am-info-container { flex-grow: 1; flex-shrink: 1; flex-basis: 0; display: flex; flex-direction: column; min-width: 0; padding: 0 0.5rem; pointer-events: none; }
            .am-name-row { display: flex; flex-direction: row; flex-wrap: wrap; align-items: baseline; }
            .am-addon-name { font-weight: 600; color: var(--am-fg); font-size: 1.6rem; margin-right: 0.5rem; line-height: 1.2; }
            .am-addon-version { font-size: 1rem; color: var(--am-fg); opacity: 0.6; font-weight: 500; }
            .am-addon-types { margin-top: 0.5rem; font-size: 1rem; color: var(--am-fg); opacity: 0.4; text-transform: capitalize; }
            .am-addon-description { margin-top: 0.5rem; font-size: 1rem; color: var(--am-fg); line-height: 1.4; }

            /* Action Buttons */
            .am-actions-group { display: flex; gap: 0.5rem; margin-left: auto; align-items: center; align-self: center; }
            .am-action-btn { 
                width: 2.5rem; height: 2.5rem; border-radius: 10px; border: 1px solid rgba(255,255,255,0.08); 
                background: rgba(255, 255, 255, 0.05); color: #fff; cursor: pointer; 
                display: flex; align-items: center; justify-content: center; 
                transition: background 0.2s ease, border-color 0.2s ease; position: relative;
            }
            .am-action-btn:hover { background: rgba(255, 255, 255, 0.15); border-color: rgba(255,255,255,0.2); z-index: 10; }
            .am-action-btn svg { width: 1.2rem; height: 1.2rem; fill: none; stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; transition: stroke 0.2s ease; }
            
            /* Hover Colors (No Animation) */
            .am-action-btn.share:hover svg { stroke: #4ade80; }
            .am-action-btn.copy:hover svg { stroke: #60a5fa; }
            .am-action-btn.reinstall:hover svg { stroke: #fbbf24; }
            .am-action-btn.configure:hover svg { stroke: #a78bfa; }

            /* Animations - Triggered on Click */
            .am-action-btn.share.animating svg { animation: amShare 0.5s ease; stroke: #4ade80; }
            .am-action-btn.copy.animating svg { animation: amPulse 0.5s ease; stroke: #60a5fa; }
            .am-action-btn.reinstall.animating svg { animation: amSpin 0.8s ease; stroke: #fbbf24; }
            .am-action-btn.configure.animating svg { animation: amWiggle 0.5s ease; stroke: #a78bfa; }
            
            .am-action-btn.delete { color: #ff3333; background: #2a0a0a; }
            .am-action-btn.delete:hover { background: #3a0f0f; border-color: #ff4444; color: #ff4444; }
            .am-action-btn.delete.animating { animation: amShake 0.5s ease; }

            @keyframes amShare { 0% { transform: translateY(0); } 50% { transform: translateY(-3px) translateX(3px); } 100% { transform: translateY(0); } }
            @keyframes amPulse { 0% { transform: scale(1); } 50% { transform: scale(1.25); } 100% { transform: scale(1); } }
            @keyframes amSpin { 0% { transform: rotate(0); } 100% { transform: rotate(360deg); } }
            @keyframes amWiggle { 0%, 100% { transform: rotate(0); } 25% { transform: rotate(-20deg); } 75% { transform: rotate(20deg); } }
            @keyframes amShake { 0%, 100% { transform: translateX(0); } 25% { transform: translateX(-3px); } 75% { transform: translateX(3px); } }

            /* Header Controls */
            .am-header-btn {
                background: transparent; color: var(--am-accent); border: 2px solid var(--am-accent);
                border-radius: 2rem; padding: 0 1.5rem; font-family: inherit; font-weight: 700;
                font-size: 0.95rem; cursor: pointer; margin-right: 12px; height: 2.8rem;
                display: inline-flex; align-items: center; justify-content: center; gap: 0.6rem;
                transition: all 0.2s ease;
            }
            .am-header-btn:hover { background: rgba(255, 255, 255, 0.08); transform: translateY(-1px); }
            .am-header-btn.active { background: var(--am-accent); color: #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }
            .am-header-btn.active:hover { filter: brightness(1.1); }
            .am-header-btn svg { width: 1.1rem; height: 1.1rem; fill: none; stroke: currentColor; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round; }

            /* Modals */
            .am-modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.8); backdrop-filter: blur(5px); z-index: 9999; display: flex; align-items: center; justify-content: center; animation: amFadeIn 0.3s ease; }
            .am-modal { background: #19191f; border: 1px solid rgba(255,255,255,0.05); padding: 2rem; border-radius: var(--am-border-radius); box-shadow: 0 20px 50px rgba(0,0,0,0.5); max-width: 450px; width: 90%; text-align: center; animation: amPopIn 0.3s ease; }
            .am-modal-title { font-size: 1.4rem; font-weight: 700; color: #fff; margin-bottom: 1rem; }
            .am-modal-text { color: #ccc; margin-bottom: 2rem; line-height: 1.5; font-size: 1rem; }
            .am-modal-btn { background: var(--am-accent); color: #fff; border: none; padding: 0.8rem 2rem; border-radius: 10px; font-weight: 700; cursor: pointer; transition: transform 0.2s, background 0.2s; font-size: 1rem; }
            .am-modal-btn:hover { filter: brightness(1.1); }
            .am-modal-btn.cancel { background: transparent; border: 1px solid #444; color: #ccc; }
            .am-modal-btn.cancel:hover { border-color: #888; color: #fff; }
            @keyframes amFadeIn { from { opacity: 0; } to { opacity: 1; } }
            @keyframes amPopIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }

            /* Backup Cards */
            /* Backup Cards */
            .am-backup-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-top: 2rem; width: 100%; }
            .am-backup-card {
                background: #111116; border: 1px solid rgba(255,255,255,0.1); border-radius: 12px;
                padding: 1.5rem 1rem; display: flex; flex-direction: column; align-items: center; justify-content: center;
                cursor: pointer; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); text-align: center; position: relative;
                min-height: 140px;
            }
            .am-backup-card:hover { background: #1a1a20; border-color: rgba(255,255,255,0.25); transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.3); }
            .am-backup-icon { width: 36px; height: 36px; margin-bottom: 1rem; opacity: 0.9; }
            .am-backup-icon svg { width: 100%; height: 100%; stroke-width: 2; }
            .am-backup-title { font-size: 1.1rem; font-weight: 700; color: #fff; margin-bottom: 0.5rem; }
            .am-backup-desc { font-size: 0.85rem; color: #888; line-height: 1.5; max-width: 90%; margin: 0 auto; }
            .am-backup-cancel { margin-top: 2.5rem; background: transparent; border: none; color: #666; cursor: pointer; font-size: 1rem; font-weight: 500; transition: color 0.2s; padding: 0.5rem 1rem; }
            .am-backup-cancel:hover { color: #eee; }
        `;
        document.head.appendChild(style);
    }

    // -- Data Logic -----------------------------------------------------------

    function loadAddons() {
        try {
            const profile = JSON.parse(localStorage.getItem('profile'));
            return profile && profile.addons ? profile.addons : [];
        } catch (e) {
            console.error('[AddonManager] Load error', e);
            return [];
        }
    }

    function saveAddons(newAddons) {
        try {
            const profile = JSON.parse(localStorage.getItem('profile'));
            if (!profile) return;

            profile.addons = newAddons;
            localStorage.setItem('profile', JSON.stringify(profile));

            if (profile.auth && profile.auth.key) {
                // Sync with API
                fetch(CONFIG.api.collectionSet, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        type: 'addonCollectionSet',
                        authKey: profile.auth.key,
                        addons: newAddons
                    })
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.result) {
                            if (window.services && window.services.core) {
                                try {
                                    window.services.core.transport.dispatch({
                                        action: 'Ctx',
                                        args: { action: 'PullAddonsFromAPI' }
                                    });

                                } catch (e) {
                                    console.error('[AddonManager] Core sync failed, reloading...', e);
                                    location.reload();
                                }
                            } else {
                                location.reload();
                            }
                        } else {
                            showModal(t('sync_failed'), data.error || t('unknown_error'));
                        }
                    })
                    .catch(err => {
                        console.error('[AddonManager] Sync error', err);
                        showModal(t('error'), t('sync_error_console'));
                    });
            } else {
                showModal(t('saved_locally'), t('login_to_sync'), () => location.reload());
            }
        } catch (e) { console.error('[AddonManager] Save error', e); }
    }

    function exportAddons() {
        try {
            const addons = loadAddons();
            const blob = new Blob([JSON.stringify(addons, null, 2)], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `stremio-addons-${new Date().toISOString().slice(0, 10)}.json`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            showModal(t('export_success'), t('export_success_msg'));
        } catch (e) {
            showModal(t('error'), t('export_failed'));
        }
    }

    function importAddons() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = '.json';
        input.onchange = e => {
            const file = e.target.files[0];
            if (!file) return;
            const reader = new FileReader();
            reader.onload = event => {
                try {
                    const imported = JSON.parse(event.target.result);
                    if (!Array.isArray(imported)) throw new Error('Invalid backup');
                    showConfirm(t('confirm_import'), t('confirm_import_msg', { count: imported.length }), () => {
                        state.addons = imported;
                        saveAddons(imported);
                    });
                } catch (err) {
                    showModal(t('import_error'), t('import_error_msg'));
                }
            };
            reader.readAsText(file);
        };
        input.click();
    }

    // -- UI Components --------------------------------------------------------

    function createButton(type, icon, onClick, extraClass = '') {
        const btn = document.createElement('button');
        btn.className = `am-action-btn ${type} ${extraClass}`;
        btn.title = t(type);
        btn.innerHTML = icon;
        btn.onclick = (e) => {
            e.stopPropagation();
            if (window.navigator && window.navigator.vibrate) {
                window.navigator.vibrate(15);
            }
            btn.classList.remove('animating');
            void btn.offsetWidth;
            btn.classList.add('animating');

            btn.addEventListener('animationend', () => {
                btn.classList.remove('animating');
            }, { once: true });
            requestAnimationFrame(() => onClick(e));
        };
        return btn;
    }

    function createAddonRow(addon, index, container) {
        const row = document.createElement('div');
        row.className = CONFIG.classes.row;
        row.setAttribute('draggable', 'true');
        row.dataset.index = index;

        const iconDiv = document.createElement('div');
        iconDiv.className = 'am-logo-container';

        const applyFallback = (target) => {
            target.innerHTML = ICONS.puzzle;
            const svg = target.querySelector('svg');
            if (svg) {
                svg.classList.add('am-addon-icon');
                Object.assign(svg.style, {
                    fill: '#F5F5F5',
                    opacity: '0.9',
                    padding: '0.5rem'
                });
            }
        };

        const logoSrc = addon.manifest.logo || addon.manifest.icon;

        if (logoSrc) {
            const img = document.createElement('img');
            img.className = 'am-addon-icon';
            img.src = logoSrc;
            img.onerror = () => applyFallback(iconDiv);
            iconDiv.appendChild(img);
        } else {
            applyFallback(iconDiv);
        }

        const infoDiv = document.createElement('div');
        infoDiv.className = 'am-info-container';

        const nameRow = document.createElement('div');
        nameRow.className = 'am-name-row';
        const name = document.createElement('div');
        name.className = 'am-addon-name';
        name.textContent = addon.manifest.name || t('unknown');
        const ver = document.createElement('div');
        ver.className = 'am-addon-version';
        ver.textContent = addon.manifest.version ? `v${addon.manifest.version}` : '';
        nameRow.append(name, ver);

        const types = document.createElement('div');
        types.className = 'am-addon-types';
        if (addon.manifest.types?.length) {
            types.textContent = addon.manifest.types.map(s => s.charAt(0).toUpperCase() + s.slice(1)).join(', ');
        }

        const desc = document.createElement('div');
        desc.className = 'am-addon-description';
        desc.textContent = addon.manifest.description || '';

        infoDiv.append(nameRow);
        if (types.textContent) infoDiv.appendChild(types);
        if (desc.textContent) infoDiv.appendChild(desc);

        // Actions
        const actionsDiv = document.createElement('div');
        actionsDiv.className = 'am-actions-group';

        actionsDiv.appendChild(createButton('share', ICONS.share, () => handleShare(addon, actionsDiv)));
        actionsDiv.appendChild(createButton('copy', ICONS.copy, () => handleCopy(addon, actionsDiv)));
        actionsDiv.appendChild(createButton('reinstall', ICONS.reinstall, () => handleReinstall(addon, actionsDiv)));

        const hints = addon.manifest.behaviorHints || {};
        if (!hints.configurationRequired && hints.configurable) {
            actionsDiv.appendChild(createButton('configure', ICONS.config, () => handleConfig(addon, actionsDiv)));
        }

        const isSystem = ['com.linvo.cinemeta', 'Cinemeta', 'org.stremio.rar'].includes(addon.manifest.id || addon.manifest.name);
        const delBtn = createButton('uninstall', ICONS.delete, () => handleDelete(addon, index, container), 'delete');
        if (isSystem) {
            delBtn.style.opacity = '0.2';
            delBtn.style.cursor = 'not-allowed';
            delBtn.title = t('system_addon');
            delBtn.disabled = true;
        }
        actionsDiv.appendChild(delBtn);

        row.append(iconDiv, infoDiv, actionsDiv);
        setupDragAndDrop(row, container);
        return row;
    }

    function renderManager(container) {
        container.innerHTML = '';

        const list = document.createElement('div');
        list.className = CONFIG.classes.container;
        state.addons.forEach((addon, i) => list.appendChild(createAddonRow(addon, i, container)));

        const footer = document.createElement('div');
        footer.style.cssText = 'display: flex; justify-content: flex-start; align-items: center; margin-top: 2rem; width: 100%; padding: 0 0.5rem;';

        const credits = document.createElement('div');
        credits.innerText = '';
        credits.style.cssText = 'font-size: 0.75rem; color: var(--am-fg); opacity: 0.5; font-weight: 600; cursor: default;';

        footer.appendChild(credits);
        container.append(list, footer);
    }

    // -- Event Handlers -------------------------------------------------------

    function handleShare(addon, btnContainer) {
        let url = addon.transportUrl.replace('/manifest.json', '').replace('manifest.json', '');
        if (url.endsWith('/')) url = url.slice(0, -1);

        showConfirm(t('open_url_confirm'), t('open_url_msg', { url }), () => {
            window.open(url, '_blank');
            triggerSuccess(btnContainer);
        });
    }

    function handleCopy(addon, btnContainer) {
        navigator.clipboard.writeText(addon.transportUrl);
        triggerSuccess(btnContainer);
    }

    function handleReinstall(addon, btnContainer) {
        const btn = btnContainer.querySelector('button');
        if (btn) btn.style.opacity = '0.5';

        fetch(addon.transportUrl)
            .then(res => res.json())
            .then(manifest => {
                if (!manifest || !manifest.id) throw new Error('Invalid Manifest');

                const index = state.addons.findIndex(x => x.transportUrl === addon.transportUrl);
                if (index > -1) {
                    state.addons[index].manifest = manifest;
                    saveAddons(state.addons);

                    const wrapper = document.getElementById(CONFIG.ids.wrapper);
                    if (wrapper) {
                        renderManager(wrapper);
                        // Try to highlight the success on the re-rendered row
                        const newRow = wrapper.querySelector(`.${CONFIG.classes.row}[data-index="${index}"]`);
                        if (newRow) {
                            const actionGroup = newRow.querySelector('.am-actions-group');
                            if (actionGroup) triggerSuccess(actionGroup);
                        }
                    }
                }
            })
            .catch(err => {
                console.error('[AddonManager] Reinstall failed', err);
                showModal(t('error'), t('import_error_msg'));
                if (btn) btn.style.opacity = '1';
            });
    }

    function handleConfig(addon, btnContainer) {
        let url = addon.transportUrl.replace('manifest.json', 'configure');
        if (url === addon.transportUrl) url += '/configure';

        showConfirm(t('open_url_confirm'), t('open_url_msg', { url }), () => {
            window.open(url, '_blank');
            triggerSuccess(btnContainer);
        });
    }

    function handleDelete(addon, index, container) {
        showConfirm(t('uninstall'), t('uninstall_confirm', { name: addon.manifest.name }), () => {
            state.addons.splice(index, 1);
            renderManager(container);
        });
    }

    function triggerSuccess(element) {
        const btn = element.querySelector('button:hover') || element;
        const originalColor = btn.style.color;
        btn.style.color = '#4affaa';
        setTimeout(() => btn.style.color = originalColor, 1000);
    }

    function setupDragAndDrop(row, container) {
        row.addEventListener('dragstart', function (e) {
            state.dragSource = this;
            e.dataTransfer.effectAllowed = 'move';
            e.dataTransfer.setData('text/html', this.innerHTML);
            this.classList.add(CONFIG.classes.dragging);
        });
        row.addEventListener('dragover', (e) => { e.preventDefault(); e.dataTransfer.dropEffect = 'move'; });
        row.addEventListener('dragenter', function () { this.classList.add(CONFIG.classes.over); });
        row.addEventListener('dragleave', function () { this.classList.remove(CONFIG.classes.over); });
        row.addEventListener('drop', function (e) {
            e.stopPropagation();
            if (state.dragSource !== this) {
                const srcIdx = parseInt(state.dragSource.dataset.index);
                const tgtIdx = parseInt(this.dataset.index);
                const item = state.addons.splice(srcIdx, 1)[0];
                state.addons.splice(tgtIdx, 0, item);
                renderManager(container);
            }
            return false;
        });
        row.addEventListener('dragend', function () {
            this.classList.remove(CONFIG.classes.dragging);
            container.querySelectorAll(`.${CONFIG.classes.row}`).forEach(r => r.classList.remove(CONFIG.classes.over));
        });
    }

    // -- Modals ---------------------------------------------------------------

    function createOverlay(html) {
        const overlay = document.createElement('div');
        overlay.className = 'am-modal-overlay';
        overlay.innerHTML = html;
        const close = () => { overlay.style.opacity = '0'; setTimeout(() => overlay.remove(), 200); };
        overlay.onclick = (e) => { if (e.target === overlay) close(); };
        document.body.appendChild(overlay);
        return { overlay, close };
    }

    function showModal(title, msg, onOk) {
        const rtl = getLanguage().startsWith('ar') ? 'direction: rtl;' : '';
        const { overlay, close } = createOverlay(`
            <div class="am-modal" style="${rtl}">
                <div class="am-modal-title">${title}</div>
                <div class="am-modal-text">${msg}</div>
                <button class="am-modal-btn">${t('ok')}</button>
            </div>
        `);
        overlay.querySelector('button').onclick = () => { close(); if (onOk) onOk(); };
    }

    function showConfirm(title, msg, onConfirm) {
        const rtl = getLanguage().startsWith('ar') ? 'direction: rtl;' : '';
        const { overlay, close } = createOverlay(`
            <div class="am-modal" style="${rtl}">
                <div class="am-modal-title">${title}</div>
                <div class="am-modal-text">${msg}</div>
                <div style="display:flex; justify-content:center; gap:15px; margin-top:10px;">
                    <button class="am-modal-btn cancel">${t('cancel')}</button>
                    <button class="am-modal-btn confirm">${t('confirm')}</button>
                </div>
            </div>
        `);
        overlay.querySelector('.confirm').onclick = () => { close(); if (onConfirm) onConfirm(); };
        overlay.querySelector('.cancel').onclick = close;
    }

    function showBackupOptions() {
        const rtl = getLanguage().startsWith('ar') ? 'direction: rtl;' : '';
        const { overlay, close } = createOverlay(`
            <div class="am-modal" style="${rtl}; max-width: 450px; padding: 2rem;">
                <div class="am-modal-title" style="font-size: 1.5rem; margin-bottom: 0.5rem; border: none; text-align: center;">${t('backup_manager')}</div>
                <div class="am-modal-text" style="color: #666; font-size: 0.9rem; margin-bottom: 0; text-align: center;">${t('manage_config')}</div>

                <div class="am-backup-grid">
                    <!-- Import Card -->
                    <div class="am-backup-card import-btn">
                        <div class="am-backup-icon" style="color: #4ade80;">
                            ${ICONS.upload}
                        </div>
                        <div class="am-backup-title">${t('import')}</div>
                        <div class="am-backup-desc">${t('import_desc')}</div>
                    </div>

                    <!-- Export Card -->
                    <div class="am-backup-card export-btn">
                        <div class="am-backup-icon" style="color: #60a5fa;">
                            ${ICONS.download}
                        </div>
                        <div class="am-backup-title">${t('export')}</div>
                        <div class="am-backup-desc">${t('export_desc')}</div>
                    </div>
                </div>

                <div style="display: flex; justify-content: center; width: 100%;">
                    <button class="am-backup-cancel">${t('cancel')}</button>
                </div>
            </div>
        `);
        overlay.querySelector('.export-btn').onclick = () => { close(); exportAddons(); };
        overlay.querySelector('.import-btn').onclick = () => { close(); importAddons(); };
        overlay.querySelector('.am-backup-cancel').onclick = close;
    }

    // -- Header Injection -----------------------------------------------------

    function toggleView() {
        const container = document.querySelector(CONFIG.selectors.stremioContainer);
        if (!container) return;

        const wrapper = document.getElementById(CONFIG.ids.wrapper);
        const toggleBtn = document.getElementById(CONFIG.ids.toggleBtn);
        const backupBtn = document.getElementById(CONFIG.ids.backupBtn);

        if (wrapper) {
            saveAddons(state.addons);
            wrapper.remove();

            if (toggleBtn) {
                toggleBtn.classList.remove('active');
                toggleBtn.innerHTML = ICONS.pencil + `<span>${t('edit_addons')}</span>`;
                toggleBtn.title = t('edit_addons');
            }
            if (backupBtn) backupBtn.remove();

        } else {
            state.addons = loadAddons();

            const newWrapper = document.createElement('div');
            newWrapper.id = CONFIG.ids.wrapper;
            newWrapper.className = CONFIG.classes.overlay;
            renderManager(newWrapper);
            container.appendChild(newWrapper);

            if (toggleBtn) {
                toggleBtn.classList.add('active');
                toggleBtn.innerHTML = ICONS.check + `<span>${t('done')}</span>`;
                toggleBtn.title = t('done');
            }

            // Inject Backup Button
            if (!backupBtn && toggleBtn && toggleBtn.parentNode) {
                const bBtn = document.createElement('button');
                bBtn.id = CONFIG.ids.backupBtn;
                bBtn.className = 'am-header-btn';
                bBtn.style.marginRight = '0.5rem';
                bBtn.style.background = 'transparent';
                bBtn.style.border = '2px solid rgba(255, 255, 255, 0.2)';
                bBtn.style.color = 'var(--am-fg)';
                bBtn.innerHTML = `<span>${t('backup_restore')}</span>`;
                bBtn.title = t('backup_restore');
                bBtn.onclick = showBackupOptions;
                toggleBtn.parentNode.insertBefore(bBtn, toggleBtn);
            }
        }
    }

    function injectControls() {
        if (!window.location.hash.includes('/addons')) return;

        const inputsContainer = document.querySelector(CONFIG.selectors.stremioHeaderInputs);
        if (!inputsContainer) return;
        const spacingDiv = inputsContainer.querySelector(CONFIG.selectors.stremioHeaderSpacing);
        if (!spacingDiv) return;

        // Ensure toggle button exists
        let btn = document.getElementById(CONFIG.ids.toggleBtn);
        if (!btn) {
            btn = document.createElement('button');
            btn.id = CONFIG.ids.toggleBtn;
            btn.className = 'am-header-btn';
            btn.innerHTML = ICONS.pencil + `<span>${t('edit_addons')}</span>`;
            btn.title = t('edit_addons');
            btn.onclick = toggleView;

            // Styling the container to ensure button is clickable and visible
            spacingDiv.style.pointerEvents = 'auto';
            spacingDiv.style.display = 'flex';
            spacingDiv.style.alignItems = 'center';
            spacingDiv.style.justifyContent = 'flex-end';
            spacingDiv.appendChild(btn);
        } else {
            // Update text if language changed or state allows
            if (!btn.classList.contains('active')) {
                const html = ICONS.pencil + `<span>${t('edit_addons')}</span>`;
                if (btn.innerHTML !== html) {
                    btn.innerHTML = html;
                    btn.title = t('edit_addons');
                }
            }
            // Ensure it's in the right place
            if (!spacingDiv.contains(btn)) spacingDiv.appendChild(btn);
        }
    }

    // -- Boot -----------------------------------------------------------------
    if (!window.addonManagerInt) {
        window.addonManagerInt = setInterval(() => {
            injectStyles();
            injectControls();
        }, 1000);
    }
})();
