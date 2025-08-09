final class SerialPortData {
  String description;
  String transport;
  String usbBus;
  String usbDevice;
  String vendorId;
  String productId;
  String manufacturer;
  String productName;
  String serialNumber;
  String macAdress;

  SerialPortData(this.description, this.transport, this.usbBus, this.usbDevice, this.vendorId, this.productId, this.manufacturer, this.productName, this.serialNumber, this.macAdress);

  // armazena o nome da variavel dada a instância da classe
  String instanceName = (SerialPortData).toString();


  // definindo como a classe deve ser impressa no console

  @override
  String toString() {
    
    return '''
        $instanceName:
        Descrição --> $description
        Transporte --> $transport
        USB Bus --> $usbBus
        Dispositivo USB --> $usbDevice
        Id do vendedor --> $vendorId
        Id do Produto --> $productId
        Fabricante --> $manufacturer
        Nome do Produto --> $productName
        N. Serial --> $serialNumber
        End. Mac --> $macAdress''';
  }
}