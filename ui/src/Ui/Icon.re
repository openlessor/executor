type iconProps = {
  .
  "absoluteStrokeWidth": option(bool),
  "className": option(string),
  "color": option(string),
  "size": option(int),
  "strokeWidth": option(int),
};

module Calendar = {
  [@mel.module "lucide-react"] [@react.component]
  external make:
    (
      ~absoluteStrokeWidth: bool=?,
      ~className: string=?,
      ~color: string=?,
      ~size: int=?,
      ~strokeWidth: int=?
    ) =>
    React.element =
    "Calendar";
};
module Clock = {
  [@mel.module "lucide-react"] [@react.component]
  external make:
    (
      ~absoluteStrokeWidth: bool=?,
      ~className: string=?,
      ~color: string=?,
      ~size: int=?,
      ~strokeWidth: int=?
    ) =>
    React.element =
    "Clock";
};

module Cart = {
  [@mel.module "lucide-react"] [@react.component]
  external make:
    (
      ~absoluteStrokeWidth: bool=?,
      ~className: string=?,
      ~color: string=?,
      ~size: int=?,
      ~strokeWidth: int=?
    ) =>
    React.element =
    "ShoppingCart";
};

module MonitorCloud = {
  [@mel.module "lucide-react"] [@react.component]
  external make:
    (
      ~absoluteStrokeWidth: bool=?,
      ~className: string=?,
      ~color: string=?,
      ~size: int=?,
      ~strokeWidth: int=?
    ) =>
    React.element =
    "MonitorCloud";
};
module SearchIcon = {
  [@mel.module "lucide-react"] [@react.component]
  external make:
    (
      ~absoluteStrokeWidth: bool=?,
      ~className: string=?,
      ~color: string=?,
      ~size: int=?,
      ~strokeWidth: int=?
    ) =>
    React.element =
    "SearchIcon";
};
