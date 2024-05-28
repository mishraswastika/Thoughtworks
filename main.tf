provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "media_rg" {
  name     = "mediaResourceGroup"
  location = "East US"
}

resource "azurerm_virtual_network" "media_vnet" {
  name                = "mediaVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.media_rg.location
  resource_group_name = azurerm_resource_group.media_rg.name
}

resource "azurerm_subnet" "media_subnet" {
  name                 = "mediaSubnet"
  resource_group_name  = azurerm_resource_group.media_rg.name
  virtual_network_name = azurerm_virtual_network.media_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "media_public_ip" {
  name                = "mediaPublicIP"
  location            = azurerm_resource_group.media_rg.location
  resource_group_name = azurerm_resource_group.media_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "net" {
  name                = "medianet"
  location            = azurerm_resource_group.media_rg.location
  resource_group_name = azurerm_resource_group.media_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.media_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.media_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "media_vm" {
  name                = "mediaVM"
  resource_group_name = azurerm_resource_group.media_rg.name
  location            = azurerm_resource_group.media_rg.location
  size                = "Standard_B1s"

  admin_username = "adminuser"
  admin_password = "P@ssw0rd1234!"
  
  network_interface_ids = [
    azurerm_network_interface.net.id,
  ]
  source_image_id       = "/sharedGalleries/9bd05406-c85b-4e5d-9b66-c8920883291a-PREVIEWCOMPUTEIMAGEGALLERY/images/RedHat/versions/latest"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
}
}
output "public_ip" {
  value = azurerm_public_ip.media_public_ip.ip_address
}

