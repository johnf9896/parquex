defmodule Parques.Core.Game do
  @moduledoc """
  A Game is the primary piece of data, representing a match of Parqués.
  """
  use TypedStruct

  import Parques.Core.Color, only: [is_color: 1]

  alias Parques.Core.Color
  alias Parques.Core.Dice
  alias Parques.Core.Player

  @max_players Color.count()
  @min_players 2

  @type id :: String.t()
  @type state :: :created | :initial_rolling | :playing | :finished

  typedstruct enforce: true do
    field :id, id()
    field :name, String.t(), default: "New game"
    field :state, state(), default: :created
    field :players, %{Player.id() => Player.t()}, default: %{}
    field :color_map, %{Color.t() => Player.id()}, default: %{}
    field :creator_id, Player.id(), enforce: false
    field :current_player_id, Player.id(), enforce: false
    field :initial_rolls, %{Player.id() => Dice.roll()}, enforce: false
    field :last_roll, Dice.roll(), enforce: false
  end

  @spec max_players :: pos_integer()
  def max_players, do: @max_players

  @spec new(Enum.t()) :: t()
  def new(fields \\ []) do
    fields =
      fields
      |> Map.new()
      |> Map.put_new_lazy(:id, &UUID.uuid4/0)

    struct!(__MODULE__, fields)
  end

  @spec set_name(t(), String.t()) :: t()
  def set_name(game, new_name) do
    %__MODULE__{game | name: new_name}
  end

  defguard is_game_player(game, player) when is_map_key(game.players, player.id)

  @spec players(t()) :: [Player.t()]
  def players(%__MODULE__{players: players, color_map: color_map}) do
    Color.list()
    |> Enum.map(fn color ->
      player_id = color_map[color]
      players[player_id]
    end)
    |> Enum.reject(&is_nil/1)
  end

  @spec creator(t()) :: Player.t() | nil
  def creator(%__MODULE__{creator_id: nil}), do: nil
  def creator(%__MODULE__{} = game), do: Map.fetch!(game.players, game.creator_id)

  @spec add_player(t(), Player.t()) :: t()
  def add_player(game, player) when is_game_player(game, player), do: game

  def add_player(%__MODULE__{players: players, state: :created} = game, player)
      when map_size(players) < @max_players do
    color_chosen = available_color(game)
    player_with_color = Player.set_color(player, color_chosen)

    new_players = Map.put(players, player.id, player_with_color)
    new_color_map = Map.put(game.color_map, color_chosen, player.id)
    creator_id = game.creator_id || player.id
    %__MODULE__{game | players: new_players, color_map: new_color_map, creator_id: creator_id}
  end

  @spec available_color(t()) :: Color.t()
  defp available_color(game), do: Color.available(colors_taken(game))

  @spec colors_taken(t()) :: [Color.t()]
  defp colors_taken(%{color_map: color_map}), do: Map.keys(color_map)

  @spec remove_player(t(), Player.t()) :: t()
  def remove_player(%__MODULE__{players: players} = game, player)
      when is_game_player(game, player) do
    {player, new_players} = Map.pop!(players, player.id)
    new_color_map = Map.delete(game.color_map, player.color)

    creator_id =
      case game do
        %{creator_id: creator_id} when creator_id == player.id ->
          new_players
          |> Map.keys()
          |> List.first()

        %{creator_id: creator_id} ->
          creator_id
      end

    %__MODULE__{game | players: new_players, color_map: new_color_map, creator_id: creator_id}
  end

  def remove_player(%__MODULE__{} = game, _player), do: game

  @spec set_player_color(t(), Player.t(), Color.t()) :: t()
  def set_player_color(game, player, color) when is_color(color) do
    case find_player_by_color(game, color) do
      nil ->
        game
        |> update_player(Player.set_color(player, color))
        |> update_color_map()

      another_player ->
        player_color = game.players[player.id].color

        game
        |> update_player(Player.set_color(player, color))
        |> update_player(Player.set_color(another_player, player_color))
        |> update_color_map()
    end
  end

  @spec find_player_by_color(t(), Color.t()) :: Player.t() | nil
  defp find_player_by_color(game, color) do
    game.players[game.color_map[color]]
  end

  @spec update_player(t(), Player.t()) :: t()
  defp update_player(game, updated_player) do
    new_players = %{game.players | updated_player.id => updated_player}

    %__MODULE__{game | players: new_players}
  end

  @spec update_color_map(t()) :: t()
  defp update_color_map(%__MODULE__{players: players} = game) do
    new_color_map =
      Enum.reduce(players, %{}, fn {_id, player}, color_map ->
        Map.put(color_map, player.color, player.id)
      end)

    %__MODULE__{game | color_map: new_color_map}
  end

  @spec start(t()) :: t()
  def start(%__MODULE__{state: :created, players: players} = game)
      when map_size(players) >= @min_players do
    first_player = game |> players() |> hd()

    %__MODULE__{
      game
      | state: :initial_rolling,
        current_player_id: first_player.id,
        initial_rolls: %{},
        last_roll: nil
    }
  end

  @spec next_player_id(t()) :: Player.id()
  def next_player_id(%__MODULE__{state: state, players: players} = game)
      when state in [:initial_rolling, :playing] do
    current_color = players[game.current_player_id].color
    next_color = Color.next(colors_taken(game), current_color)
    game.color_map[next_color]
  end
end
