defmodule ExfileMemory.Backend do
  use Exfile.Backend

  alias Exfile.LocalFile

  def init(opts) do
    {:ok, backend} = super(opts)
    {:ok, table_manager} = ExfileMemory.Supervisor.start_backend
    put_in(backend.meta, %{
      table_manager: table_manager,
      table_id: ExfileMemory.TableManager.table(table_manager)
    })
  end

  def upload(backend, local_file) do
    id = backend.hasher.hash(local_file)
    {:ok, io} = LocalFile.open(local_file)
    :ets.insert(backend.meta.table_id, {id, IO.binread(io, :all)})
    {:ok, %Exfile.File{backend: backend, id: id}}
  end

  def delete(backend, id) do
    :ets.delete(backend.meta.table_id, id)
    :ok
  end

  def open(backend, id) do
    case :ets.lookup(backend.meta.table_id, id) do
      [{^id, object} | _] ->
        {:ok, io} = File.open(object, [:read, :binary, :ram])
        {:ok, %LocalFile{io: io}}
      _ ->
        {:error, :enoent}
    end
  end

  def size(backend, id) do
    case :ets.lookup(backend.meta.table_id, id) do
      [{^id, object} | _] ->
        {:ok, IO.iodata_length(object)}
      _ ->
        {:error, :enoent}
    end
  end

  def exists?(backend, id) do
    case :ets.lookup(backend.meta.table_id, id) do
      [{^id, _} | _] ->
        true
      _ ->
        false
    end
  end
end
