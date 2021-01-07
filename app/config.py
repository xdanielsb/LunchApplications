class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = "this-really-needs-to-be-changed"
    # max file size 16MB
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024
