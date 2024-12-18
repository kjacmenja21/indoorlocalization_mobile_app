import 'dart:async';
import 'dart:developer';

import 'package:il_core/il_exceptions.dart';
import 'package:multicast_dns/multicast_dns.dart';

class BackendDiscovery {
  Future<String> discoverBackendAddress(String serviceName, String targetName) async {
    var completer = Completer<String>();
    _backendAddressDiscovery(completer, serviceName, targetName);
    return completer.future;
  }

  void _backendAddressDiscovery(Completer<String> completer, String serviceName, String targetName) async {
    var client = MDnsClient();

    log('Start MDNS discovery');
    await client.start();

    await for (final PtrResourceRecord ptr in client.lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(serviceName))) {
      await for (final SrvResourceRecord srv in client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(ptr.domainName))) {
        await for (final IPAddressResourceRecord ip in client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(srv.target))) {
          if (srv.target == targetName) {
            if (completer.isCompleted == false) {
              log('Found backend address: ${ip.address.address}');
              completer.complete(ip.address.address);
            }
          }
        }
      }
    }

    if (completer.isCompleted == false) {
      completer.completeError(AppException('Backend is not working!'));
    }

    client.stop();
    log('Stop MDNS Discovery');
  }
}
