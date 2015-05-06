defmodule Hyperledger.Validations do
  use Ecto.Model
  
  alias Hyperledger.Repo
  
  def validate_encoding(changeset, field) do
    validate_change changeset, field, fn field, value ->
      case Base.decode32(value) do
        :error -> [{field, :not_base_32_encoded}]
        {:ok, _} -> []
      end
    end
  end
  
  def validate_existence(changeset, field, model) do
    validate_change changeset, field, fn field, value ->
      case Repo.get(model, value) do
        nil -> [{field, :does_not_exist}]
        _ -> []
      end
    end
  end
end
