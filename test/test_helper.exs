{:ok, _} = Application.ensure_all_started(:ex_machina)

Mimic.copy(Parques.Core.Dice)

ExUnit.configure(formatters: [ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start()
