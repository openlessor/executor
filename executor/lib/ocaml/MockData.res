type mockNetworkHardwareItem = {
  vendor: string,
  category: string,
  name: string,
  exampleModels: array<string>,
  description: string,
}

let mockNetworkHardware: array<mockNetworkHardwareItem> = [
  {
    vendor: "Cisco",
    category: "Router",
    name: "Catalyst 8300 Series",
    exampleModels: ["C8300-1N1S-6T"],
    description: "Enterprise edge/branch routers with SD-WAN capabilities.",
  },
  {
    vendor: "Cisco",
    category: "Router",
    name: "ASR 1000 Series",
    exampleModels: ["ASR1001-X"],
    description: "Aggregation Services Routers for enterprise edge and service provider networks.",
  },
  {
    vendor: "Cisco",
    category: "Router",
    name: "ISR 4000 Series",
    exampleModels: ["ISR4321/K9"],
    description: "Integrated services routers for branches offering routing, security, and WAN optimization.",
  },
  {
    vendor: "Cisco",
    category: "Switch",
    name: "Catalyst 9300 Series",
    exampleModels: ["C9300-48P-E"],
    description: "Stackable access switches for campus/branch networks with PoE+ options.",
  },
  {
    vendor: "Cisco",
    category: "Switch",
    name: "Catalyst 9500 Series",
    exampleModels: ["9500 Series"],
    description: "Fixed-core and aggregation switches for large campuses.",
  },
  {
    vendor: "Cisco",
    category: "Switch",
    name: "Nexus 9000 Series",
    exampleModels: ["9000 Series"],
    description: "Data center switches for cloud-scale environments.",
  },
  {
    vendor: "Juniper",
    category: "Router",
    name: "MX Series",
    exampleModels: ["MX240"],
    description: "Universal edge routers for large-scale, highly scalable deployments.",
  },
  {
    vendor: "Juniper",
    category: "Security Appliance",
    name: "SRX Series",
    exampleModels: ["SRX345"],
    description: "Firewalls with integrated routing and security functions.",
  },
  {
    vendor: "Juniper",
    category: "Switch",
    name: "EX Series",
    exampleModels: ["EX3400-48P", "EX4400-48MP"],
    description: "Access/aggregation switches with PoE+ and Virtual Chassis.",
  },
  {
    vendor: "Juniper",
    category: "Switch",
    name: "QFX Series",
    exampleModels: ["QFX5100"],
    description: "High-performance data center and campus switches.",
  },
  {
    vendor: "HPE Aruba",
    category: "Switch",
    name: "CX 6100/6200 Series",
    exampleModels: ["6100 Series", "6200 Series"],
    description: "Entry-level and stackable access switches for SMB/branch use.",
  },
  {
    vendor: "HPE Aruba",
    category: "Switch",
    name: "CX 6300 Series",
    exampleModels: ["6300 Series"],
    description: "Stackable access/aggregation switches with high-power PoE.",
  },
  {
    vendor: "HPE Aruba",
    category: "Switch",
    name: "Instant On 1930 Series",
    exampleModels: ["1930 Series"],
    description: "Cost-effective managed switches for small and growing businesses.",
  },
  {
    vendor: "HPE Aruba",
    category: "Access Point",
    name: "AP-505 Series",
    exampleModels: ["AP-505"],
    description: "Wi-Fi 6 APs for everyday enterprise use.",
  },
  {
    vendor: "HPE Aruba",
    category: "Access Point",
    name: "AP-630 Series",
    exampleModels: ["AP-630"],
    description: "Wi-Fi 6E APs for future-ready, high-density deployments.",
  },
  {
    vendor: "Fortinet",
    category: "Security Appliance",
    name: "FortiGate 100F",
    exampleModels: ["FG-100F"],
    description: "Next-gen firewall for mid-sized to large enterprise branches.",
  },
  {
    vendor: "Fortinet",
    category: "Security Appliance",
    name: "FortiGate 60F",
    exampleModels: ["FG-60F"],
    description: "Security appliance for small to mid-sized businesses.",
  },
  {
    vendor: "Fortinet",
    category: "Switch",
    name: "FortiSwitch 100 Series",
    exampleModels: ["FS-148F"],
    description: "Secure access switches tightly integrated with FortiGate.",
  },
  {
    vendor: "Fortinet",
    category: "Switch",
    name: "FortiSwitch 600 Series",
    exampleModels: ["FS-624F"],
    description: "High-performance campus switches with security integration.",
  },
]

let createMockData = (~client, premise_id: string) => {
  let query = %sql.execute(`
  INSERT INTO inventory (premise_id, name, description, quantity)
  SELECT
    :premise_id!,
    mock_inventory.name,
    mock_inventory.description,
    0
  FROM json_populate_recordset(null::inventory, :mock_inventory!) as mock_inventory
  RETURNING *;
  `)
  let mockInventoryJson = mockNetworkHardware->JSON.stringifyAny->Belt.Option.getUnsafe->JSON.String

  client->query({premise_id, mock_inventory: mockInventoryJson})
}
