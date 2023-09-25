defmodule Battleship.Action do
  @moduledoc """
  The actions for a Battleship game
  """
  import Ecto.Query, warn: false

  alias Battleship.Action.Placement
  alias Battleship.Repo

  @carrier 5
  @battleship 4
  @cruiser 3
  @submarine 3
  @destroyer 2

  def place_ship([ship, _direction, _position])
      when ship not in ["Carrier", "Battleship", "Cruiser", "Submarine", "Destroyer"] do
    IO.puts("Not a proper ship")
  end

  def place_ship([_ship, direction, _position]) when direction not in ["down", "right"] do
    IO.puts("Not a proper direction")
  end

  def place_ship([ship, direction, position]) do
    query = from(p in Placement, where: p.ship == ^ship)

    if Repo.exists?(query) do
      IO.puts("That ship has already been placed")
    else
      coordinate_list = build_coordinate_list_and_insert(ship, direction, position)
      insert_placements(coordinate_list, ship)
    end
  end

  def place_ship(_) do
    IO.puts("Invalid placement. Use --placeship=\"Ship direction coordinates\" to place a ship")
  end

  def shot(coordinate) do
    with {:within_grid, true} <- {:within_grid, coordinate in Placement.valid_grid()},
         shot_result = check_shot(coordinate),
         {:hit, %Placement{} = placement} <- {:hit, shot_result} do
      mark_hit(placement)
      ship_sunk?(shot_result)
    else
      {:within_grid, false} -> IO.puts("Off the grid")
      {:hit, _} -> IO.puts("Miss")
    end
  end

  defp build_coordinate_list_and_insert(ship, direction, position) do
    ship_sizes = %{
      "Carrier" => @carrier,
      "Battleship" => @battleship,
      "Cruiser" => @cruiser,
      "Submarine" => @submarine,
      "Destroyer" => @destroyer
    }

    case Map.get(ship_sizes, ship) do
      nil -> nil
      size -> set_ship_coordinates(size, direction, position)
    end
  end

  defp insert_placements(coordinate_list, ship) do
    multi = Ecto.Multi.new()

    # Build a multi-operation transaction to insert placements
    final_multi =
      Enum.reduce(coordinate_list, multi, fn coordinate, acc_multi ->
        changeset = Placement.changeset(%Placement{}, %{ship: ship, cell: coordinate})

        Ecto.Multi.insert(acc_multi, {:placement, coordinate}, changeset)
      end)

    case Repo.transaction(final_multi) do
      {:ok, _} ->
        IO.puts("Placed #{ship}")

      {:error, {_placement, failed_value}, changeset, _changes_so_far} ->
        process_error(failed_value, changeset)
    end
  end

  defp process_error(failed_value, changeset) do
    {_cell, {error, _}} = List.first(changeset.errors)

    case error do
      "has already been taken" ->
        IO.puts("#{failed_value} is already occupied")

      "is invalid" ->
        IO.puts("Ship placement failed, #{failed_value} is outside the grid")
    end
  end

  defp set_ship_coordinates(size, "down", position) do
    [_, letter, number] = split_coordinate(position)

    initial_ascii = String.to_charlist(letter) |> hd()

    Enum.map(0..(size - 1), fn i ->
      incremented_letter = <<initial_ascii + i::utf8>>
      incremented_letter <> number
    end)
  end

  defp set_ship_coordinates(size, "right", position) do
    [_, letter, number] = split_coordinate(position)

    Enum.map(0..(size - 1), fn i ->
      incremented_number = String.to_integer(number) + i
      letter <> Integer.to_string(incremented_number)
    end)
  end

  defp split_coordinate(position), do: Regex.run(~r/([a-zA-Z]+)(\d+)/, position)

  defp check_shot(coordinate) do
    query = from(p in Placement, where: p.cell == ^coordinate)
    Repo.one(query)
  end

  defp mark_hit(shot_placement) do
    shot_placement
    |> Placement.changeset(%{hit: true})
    |> Repo.update()

    IO.puts("Hit")
  end

  defp ship_sunk?(%{ship: ship} = _shot_placement) do
    query = from(p in Placement, where: p.ship == ^ship and not p.hit)

    unless Repo.exists?(query) do
      IO.puts("You sunk my #{ship}!")
      game_over?()
    end
  end

  defp game_over? do
    query = from(p in Placement, where: not p.hit)

    unless Repo.exists?(query) do
      IO.puts("Game Over")
    end
  end
end
