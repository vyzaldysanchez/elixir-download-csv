defmodule App.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :string)
      add(:charter, :string)
      add(:bank_account, :string)
      add(:payable_amount, :decimal)

      timestamps()
    end
  end
end