type iconProps = {
  size?: int,
  color?: string,
  strokeWidth?: int,
  absoluteStrokeWidth?: bool,
  className?: string,
}

module type Icon = {
  let make: React.component<iconProps>
}

module Calendar: Icon = {
  @module("lucide-react")
  external make: React.component<iconProps> = "Calendar"
}

module Clock: Icon = {
  @module("lucide-react")
  external make: React.component<iconProps> = "Clock"
}

module MonitorCloud: Icon = {
  @module("lucide-react")
  external make: React.component<iconProps> = "MonitorCloud"
}

module Cloud: Icon = {
  @module("lucide-react")
  external make: React.component<iconProps> = "Cloud"
}

module SearchIcon: Icon = {
  @module("lucide-react")
  external make: React.component<iconProps> = "SearchIcon"
}

module IconButton = {
  @react.component
  let make = (~icon: module(Icon)) => {
    module Icon = unpack(icon)

    <button>
      <Icon size={16} color="white" /> // This is the prop
    </button>
  }
}

let _ = <IconButton icon={module(Cloud)} />
