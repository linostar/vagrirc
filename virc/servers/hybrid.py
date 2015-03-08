#!/usr/bin/env python3
# VagrIRC Virc library
import os
from zipfile import ZipFile

import requests

from .base import BaseServer


def get_members(zip):
    """get_members for zipfile, stripping common directory prefixes.

    Taken from http://stackoverflow.com/questions/8689938
    """
    parts = []
    for name in zip.namelist():
        if not name.endswith('/'):
            parts.append(name.split('/')[:-1])
    prefix = os.path.commonprefix(parts) or ''
    if prefix:
        prefix = '/'.join(prefix) + '/'
    offset = len(prefix)
    for zipinfo in zip.infolist():
        name = zipinfo.filename
        if len(name) > offset:
            zipinfo.filename = name[offset:]
            yield zipinfo


class HybridServer(BaseServer):
    """Implements support for the Hybrid IRCd."""
    name = 'hybrid'
    release = '8.2.5'
    def download_release(self):
        url = 'https://github.com/ircd-hybrid/ircd-hybrid/archive/{}.zip'.format(self.release)
        cache_folder = os.path.join(self.cache_directory, self.release)

        # see if it already exists
        if os.path.exists(cache_folder):
            return True

        # download archive
        tmp_filename = os.path.join(self.cache_directory, 'tmp_download.zip')
        with open(tmp_filename, 'wb') as handle:
            r = requests.get(url, stream=True)

            if not r.ok:
                return False

            ONE_MEGABYTE = 1024 * 1024
            for block in r.iter_content(ONE_MEGABYTE):
                if not block:
                    break
                handle.write(block)

        # unzip into directory
        with ZipFile(tmp_filename, 'r') as source_zip:
            source_zip.extractall(cache_folder, get_members(source_zip))
