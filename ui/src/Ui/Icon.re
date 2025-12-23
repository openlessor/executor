type iconProps = {
  .
  size: int,
  color: string,
  strokeWidth: int,
  absoluteStrokeWidth: bool,
  className: string,
};

module type Icon = {
  let make: React.component(iconProps);
};

module Calendar: Icon = {
  [@mel.module "lucide-react"]
  external make: React.component(iconProps) = "Calendar";
};

module Clock: Icon = {
  [@mel.module "lucide-react"]
  external make: React.component(iconProps) = "Clock";
};

module MonitorCloud: Icon = {
  [@mel.module "lucide-react"]
  external make: React.component(iconProps) = "MonitorCloud";
};

module Cloud: Icon = {
  [@mel.module "lucide-react"]
  external make: React.component(iconProps) = "Cloud";
};

module SearchIcon: Icon = {
  [@mel.module "lucide-react"]
  external make: React.component(iconProps) = "SearchIcon";
};

/*module IconButton = {
    [@react.component]
    let make = (~icon: Icon) => {
      <button>
        <Icon size={16} color="white" /> // This is the prop
      </button>
    }
  }

  let _ = <IconButton icon={module(Cloud)} />
  */
