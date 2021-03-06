#!/usr/bin/env python3
# VagrIRC Virc library

# Written in 2015 by Daniel Oaks <daniel@danieloaks.net>
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

import networkx as nx


class IrcNetwork(nx.Graph):
    """Represents an IRC network."""
    ...


class MapBaseServer:
    """Represents a server in some capacity."""
    client = False  # connects to clients
    hidden = False  # hidden to clients
    services = False  # provides services
    service_bot = False  # is a service bot

    def __init__(self, network, software):
        self.network = network
        self.software = software  # name of the software package powering this node

        self.network.add_node(self)

    def link_to(self, server, info=None):
        """Link to the given server."""
        self.network.add_edge(self, server)
        if info:
            link = (self, server)
            nx.set_edge_attributes(self.network, link, info)

    @property
    def folder_slug(self):
        """Returns a slug we use in folder names."""
        prefix = ''

        if self.client:
            prefix = 'client'
        elif self.service_bot:
            prefix = 'service_bot'
        elif self.services:
            pass
        else:
            raise Exception('this node type not implemented: {}'.format(self))

        slug = '{}{}{}'.format(prefix,
                               '_' if prefix else '',
                               self.info.get('name', '').split('_')[0])

        return slug


class MapClientServer(MapBaseServer):
    """Represents a client-facing server."""
    client = True


class MapServicesServer(MapBaseServer):
    """Represents a services server."""
    services = True
    hidden = True


class MapServiceBot(MapBaseServer):
    """Represents a service bot."""
    service_bot = True
    hidden = True


def network_stats(network):
    """Counts the types of servers in the given network."""
    stats = {
        'servers': 0,
        'client_servers': 0,
        'service_servers': 0,
        'service_bots': 0,

        'shown': 0,
        'hidden': 0,
    }

    for server in network.nodes():
        stats['servers'] += 1

        if server.client:
            stats['client_servers'] += 1
        elif server.services:
            stats['service_servers'] += 1
        elif server.service_bot:
            stats['service_servers'] += 1

        if server.hidden:
            stats['hidden'] += 1
        else:
            stats['shown'] += 1

    return stats
