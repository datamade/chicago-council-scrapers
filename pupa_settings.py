import logging
import os
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration
from sentry_sdk.integrations.logging import LoggingIntegration


def before_send(event, hint):
    """
    Filter out UnresolvedIdError events
    """
    exception_values = event.get('exception', {}).get('values', [])
    for exception in exception_values:
        print(exception)
        for value in exception:
            if value.get('type') == 'UnresolvedIdError':
                return None
    
    return event


sentry_logging = LoggingIntegration(level=logging.INFO, event_level=logging.FATAL)

sentry_sdk.init(
    dsn=os.getenv("SENTRY_DSN", "dev"),
    integrations=[DjangoIntegration(), sentry_logging],
    before_send=before_send,
)

STATIC_ROOT = '/tmp'
DATABASE_URL = os.environ.get('DATABASE_URL', 'postgis://postgres:@localhost:32005/opencivicdata')

INSTALLED_APPS = (
    'django.contrib.contenttypes',
    'opencivicdata.core.apps.BaseConfig',
    'opencivicdata.legislative.apps.BaseConfig',
    'pupa',
    'councilmatic_core'
)


LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': "%(asctime)s %(levelname)s %(name)s: %(message)s",
            'datefmt': '%m/%d/%Y %H:%M:%S'
        }
    },
    'handlers': {
        'default': {'level': 'INFO',
                    'class': 'pupa.ext.ansistrm.ColorizingStreamHandler',
                    'formatter': 'standard'
                   },
    },
    "loggers": {
        "": {"handlers": ["default"], "level": "DEBUG", "propagate": True},
        "scrapelib": {"handlers": ["default"], "level": "INFO", "propagate": False},
        "requests": {"handlers": ["default"], "level": "WARN", "propagate": False},
        "boto": {"handlers": ["default"], "level": "WARN", "propagate": False},
    },
}
