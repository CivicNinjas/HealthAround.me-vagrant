postgres:
    users:
        healthgeist:
            password: healthgeist
    app_owner: healthgeist
    app_db: healthgeist

django:
    allowed_host: '*'
    db_engine: postgres
    db_engine_module: django.contrib.gis.db.backends.postgis
    secret_key: ThisIsABadSecretBecauseItCameFromAPublicRepo
    debug: 'True'
    template_debug: 'True'
