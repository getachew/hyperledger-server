defmodule Hyperledger.ParamsHelpers do
  
  def underscore_keys(map) when is_map(map) do
    for {k, v} <- map, into: %{}, do:
      {Phoenix.Naming.underscore(k), underscore_keys(v)}
  end
  
  def underscore_keys(value) do
    value
  end
  
end