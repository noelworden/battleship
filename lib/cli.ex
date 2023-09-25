defmodule CLI do
  alias Battleship.Action

  def main(args) do
    opts = [switches: [placeship: :string, fire: :string]]

    {options, _remaining_args, _invalid} = OptionParser.parse(args, opts)

    process_options(options)
  end

  defp process_options(options) do
    case options do
      [placeship: placement] ->
        Action.place_ship(String.split(placement))

      [fire: coordinate] ->
        Action.shot(coordinate)

      _ ->
        IO.puts(
          "Invalid option. Use --placeship=\"Ship direction coordinates\" to place a ship, or --fire \"coordinate\" to fire"
        )
    end
  end
end
