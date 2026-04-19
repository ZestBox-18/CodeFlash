@ObservedV2
export class DiscoveredDevice {
  @Trace ip: string = '';
  @Trace hostname: string = '';

  constructor(ip: string, hostname: string) {
    this.ip = ip;
    this.hostname = hostname;
  }
}
