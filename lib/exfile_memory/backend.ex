defmodule ExfileMemory.Backend do
  use Exfile.Backend

  def init(opts) do
    {:ok, backend} = super(opts)
    {:ok, table_manager} = ExfileMemory.Supervisor.start_backend
    put_in(backend.meta, %{
      table_manager: table_manager,
      table_id: ExfileMemory.TableManager.table(table_manager)
    })
  end

  def upload(backend, uploadable) do
    id = backend.hasher.hash(uploadable)
    :ets.insert(backend.meta.table_id, {id, IO.read(uploadable, :all)})
    {:ok, %Exfile.File{backend: backend, id: id}}
  end

  def delete(backend, id) do
    :ets.delete(backend.meta.table_id, id)
    :ok
  end

  def open(backend, id) do
    case :ets.lookup(backend.meta.table_id, id) do
      [{^id, object} | _] ->
        StringIO.open(object)
      _ ->
        {:error, :notexist}
    end
  end

  def size(backend, id) do
    case :ets.lookup(backend.meta.table_id, id) do
      [{^id, object} | _] ->
        {:ok, byte_size(object)}
      _ ->
        {:error, :notexist}
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
