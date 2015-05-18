defmodule Hyperledger.ParamsHelpers do  
  def underscore_keys(map) when is_map(map) do
    for {k, v} <- map, into: %{}, do:
      {underscore(k), underscore_keys(v)}
  end
  
  def underscore_keys(value) do
    value
  end
  
  defp underscore(value) when is_atom(value) do
    Atom.to_string(value) |> underscore
  end
  
  defp underscore(value) do
    Phoenix.Naming.underscore(value)
  end
  
end