type numberFormatter
type numberFormatOptions

@scope("Intl")
external make: (string, numberFormatOptions) => numberFormatter = "NumberFormat"

@send external format: (numberFormatter, float) => string = "format"

@obj
external makeOptions: (~style: string, ~currency: string, unit) => numberFormatOptions = ""

let formatCurrency = (amount: float, ~locale: option<string>=?, ~currency: option<string>=?) => {
  let locale_ = locale->Belt.Option.getWithDefault("en-US")
  let currency_ = currency->Belt.Option.getWithDefault("USD")

  let formatter = make(locale_, makeOptions(~style="currency", ~currency=currency_, ()))

  formatter->format(amount)
}
