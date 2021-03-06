defmodule CambiatusWeb.Schema do
  @moduledoc """
  This module holds the implementation for the GraphQL schema for Cambiatus, use this module
  to add and remove middleware from the schema and define its root shape
  """
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :classic

  alias Cambiatus.{
    Commune,
    Kyc
  }

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Commune, Commune.data())
      |> Dataloader.add_source(Kyc, Kyc.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  import_types(Absinthe.Type.Custom)
  import_types(__MODULE__.AccountTypes)
  import_types(__MODULE__.CommuneTypes)
  import_types(__MODULE__.NotificationTypes)
  import_types(__MODULE__.RelayTypes)
  import_types(__MODULE__.KycTypes)

  query do
    import_fields(:account_queries)
    import_fields(:community_queries)
    import_fields(:notification_queries)
    import_fields(:address_queries)
  end

  mutation do
    import_fields(:account_mutations)
    import_fields(:notification_mutations)
    import_fields(:kyc_mutations)
    import_fields(:commune_mutations)
  end

  subscription do
    import_fields(:community_subscriptions)
    import_fields(:notifications_subscriptions)
  end
end
