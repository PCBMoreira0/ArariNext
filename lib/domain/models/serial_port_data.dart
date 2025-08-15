final class SerialPortData {
  final String name;
  final int adress;
  final String description;
  final String transport;
  final String usbBus;
  final String usbDevice;
  final String vendorId;
  final String productId;
  final String manufacturer;
  final String productName;
  final String serialNumber;
  final String macAdress;

  SerialPortData(this.name, this.adress, this.description, this.transport, this.usbBus, this.usbDevice, this.vendorId, this.productId, this.manufacturer, this.productName, this.serialNumber, this.macAdress);

  // armazena o nome da variavel dada a instância da classe
  String instanceName = (SerialPortData).toString();


  // definindo como a classe deve ser impressa no console

  @override
  String toString() {
    
    return '''
        $instanceName:
        Nome da Porta --> $name
        Endereço --> $adress
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