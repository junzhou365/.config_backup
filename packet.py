auth_unix_params = {
    'credentials_stamp': int(0x57678f89),
    'machine_name_contents': 'JZMacP',
    'uid': 0,
    'gid': 0,
    'auxiliary_gids': [1,2,3,4,5,8,9,12,20,29,61,80],
}

rpc_params = {
    'xid': int(0x4d35bb69),
    'message_type': 0,
    'rpc_version': 2,
    'program': 100024,
    'program_version': 1,
    'procedure': 6,
    'credentials_flavor': 0,
    'verifier_flavor': 0,
    'verifier_length': 0
}

nsm_params = {
    'mon_name': 'JZMacP',
    'state': 1101
}

portmap_params = {
    'prog': 100024,
    'vers': 1,
    'prot': 17,
    'port': 0
}

from collections import OrderedDict
from struct import *
from scapy.all import *

def _pad_string(s):
    width = 4 - (len(s) % 4) + len(s) if len(s) % 4 != 0 else 0
    return s.ljust(width, '\x00')

def _encode(d):
    output = ""
    for k in d:
        v = d[k]
        print ("  " if 'auth' not in d else "") + k, v
        if type(v) == int:
            output += pack('>l', v)
        elif type(v) == str:
            output += v
        elif type(v) == list:
            output += pack('>l', len(v))
            output += ''.join(map(lambda x: pack('>l', x), v))
        else:
            output += v.bytes()
    return output

def bytes_diff(a, b):
    assert len(a) == len(b)
    for i, x, y in zip(range(len(a)), a, b):
        if x != y:
            print i, x, y, ord(x), ord(y)

class AUTH_NULL:
    def __init__(self):
        self.od = OrderedDict()
        self.length = 0

    def bytes(self):
        return _encode(self.od)

class AUTH_UNIX(AUTH_NULL):
    def __init__(self, **kwargs):
        AUTH_NULL.__init__(self)
        od = self.od
        od['credentials_stamp'] = kwargs['credentials_stamp']
        od['machine_name_length'] = len(kwargs['machine_name_contents'])
        od['machine_name_contents'] = _pad_string(kwargs['machine_name_contents'])
        od['uid'] = kwargs['uid']
        od['gid'] = kwargs['gid']
        od['auxiliary_gids'] = kwargs['auxiliary_gids']
        self.length = 17 * 4 + len(od['machine_name_contents'])


class RPC:
    def __init__(self, **kwargs):
        od = OrderedDict()
        self.od = od
        self.auth = self._initialize_auth(kwargs['credentials_flavor'])

        od['xid'] = kwargs['xid']
        od['message_type'] = kwargs['message_type']
        od['rpc_version'] = kwargs['rpc_version']
        od['program'] = None
        od['program_version'] = None
        od['procedure'] = None
        od['credentials_flavor'] = kwargs['credentials_flavor']
        od['credentials_length'] = self.auth.length
        od['auth'] = self.auth
        od['verifier_flavor'] = kwargs['verifier_flavor']
        od['verifier_length'] = kwargs['verifier_length']

    def _initialize_auth(self, flavor):
        auth = None
        if flavor == 0:
            auth = AUTH_NULL()
        elif flavor == 1:
            auth = AUTH_UNIX(**auth_unix_params)
        return auth

    def bytes(self, type):
        if type == 'nsm':
            self.od['program'] = 100024
            self.od['program_version'] = 1
            self.od['procedure'] = 6
        elif type == 'portmap':
            self.od['program'] = 100000
            self.od['program_version'] = 2
            self.od['procedure'] = 3

        return _encode(self.od)


class NLM:
    def __init__(self):
        od = OrderedDict()
        self.od = od

class NSM:
    def __init__(self, **kwargs):
        od = OrderedDict()
        self.od = od
        od['mon_name_length'] = len(kwargs['mon_name'])
        od['mon_name'] = _pad_string(kwargs['mon_name'])
        od['state'] = kwargs['state']

    def bytes(self):
        return _encode(self.od)

class PortMap:
    def __init__(self, **kwargs):
        od = OrderedDict()
        self.od = od
        od['prog'] = kwargs['prog']
        od['vers'] = kwargs['vers']
        od['prot'] = kwargs['prot']
        od['port'] = kwargs['port']

    def bytes(self):
        return _encode(self.od)

rpc = RPC(**rpc_params)
nsm = NSM(**nsm_params)
portmap = PortMap(**portmap_params)

def send_rpc(sport, dport=111):
    load = rpc.bytes('portmap') + portmap.bytes()
    base = IP(dst="192.168.199.154")/UDP(sport=sport, dport=dport)/load
    send(base)

def send_nsm(sport, dport):
    load = rpc.bytes('nsm') + nsm.bytes()
    base = IP(dst="192.168.199.154")/UDP(sport=sport, dport=dport)/load
    send(base)

def main():
    pass

if __name__ == "__main__":
    main()
