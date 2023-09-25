defmodule Battleship.ActionTest do
  use Battleship.DataCase, async: true

  import ExUnit.CaptureIO

  alias Battleship.Action
  alias Battleship.Action.Placement
  alias Battleship.Repo

  describe "a ship" do
    test "can be placed on the grid" do
      message = "Placed Cruiser\n"

      output =
        capture_io(fn ->
          Action.place_ship(["Cruiser", "right", "C5"])
        end)

      assert output == message
    end

    test "is placed correctly when direction is 'right'" do
      _carrier = Action.place_ship(["Carrier", "right", "C5"])

      query = from(p in Placement, where: p.ship == "Carrier", select: p.cell)
      result = Repo.all(query)

      assert Enum.sort(result) == Enum.sort(["C5", "C6", "C7", "C8", "C9"])
    end

    test "is placed correctly when direction is 'down'" do
      _carrier = Action.place_ship(["Carrier", "down", "C5"])

      query = from(p in Placement, where: p.ship == "Carrier", select: p.cell)
      result = Repo.all(query)

      assert Enum.sort(result) == Enum.sort(["C5", "D5", "E5", "F5", "G5"])
    end

    test "cannot be placed if it is already on the board" do
      _cruiser = Action.place_ship(["Cruiser", "right", "A1"])

      message = "That ship has already been placed\n"

      output =
        capture_io(fn ->
          Action.place_ship(["Cruiser", "right", "C5"])
        end)

      assert output == message
    end

    test "cannot overlap an already placed ship" do
      _cruiser = Action.place_ship(["Cruiser", "right", "A1"])

      message = "A1 is already occupied\n"

      output =
        capture_io(fn ->
          Action.place_ship(["Submarine", "down", "A1"])
        end)

      assert output == message
    end

    test "cannot be placed off the grid" do
      message = "Ship placement failed, A12 is outside the grid\n"

      output =
        capture_io(fn ->
          Action.place_ship(["Submarine", "down", "A12"])
        end)

      assert output == message
    end

    test "cannot be placed if its a non-existent ship" do
      message = "Not a proper ship\n"

      output =
        capture_io(fn ->
          Action.place_ship(["Sailboat", "down", "A1"])
        end)

      assert output == message
    end

    test "cannot be placed if its the wrong direction" do
      message = "Not a proper direction\n"

      output =
        capture_io(fn ->
          Action.place_ship(["Cruiser", "up", "A1"])
        end)

      assert output == message
    end

    test "cannot be placed the input data is in the wrong shape" do
      message =
        "Invalid placement. Use --placeship=\"Ship direction coordinates\" to place a ship\n"

      output =
        capture_io(fn ->
          Action.place_ship(["Cruiser", "up"])
        end)

      assert output == message
    end
  end

  describe "a shot" do
    test "hits" do
      _cruiser = Action.place_ship(["Cruiser", "right", "A1"])

      message = "Hit\n"

      output =
        capture_io(fn ->
          Action.shot("A1")
        end)

      assert output == message
    end

    test "misses" do
      message = "Miss\n"

      output =
        capture_io(fn ->
          Action.shot("A1")
        end)

      assert output == message
    end

    test "sinks a ship" do
      _cruiser = Action.place_ship(["Cruiser", "right", "A1"])
      _destroyer = Action.place_ship(["Destroyer", "down", "B1"])
      _shot = Action.shot("B1")

      message = "Hit\nYou sunk my Destroyer!\n"

      output =
        capture_io(fn ->
          Action.shot("C1")
        end)

      assert output == message
    end

    test "ends the game" do
      _cruiser = Action.place_ship(["Cruiser", "right", "A1"])
      _destroyer = Action.place_ship(["Destroyer", "down", "B1"])
      _shot01 = Action.shot("A1")
      _shot02 = Action.shot("A2")
      _shot03 = Action.shot("A3")
      _shot04 = Action.shot("B1")

      message = "Hit\nYou sunk my Destroyer!\nGame Over\n"

      output =
        capture_io(fn ->
          Action.shot("C1")
        end)

      assert output == message
    end
  end
end
