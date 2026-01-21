@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Manajemen Statistik</h1>
    <a href="/admin/statistics/create" class="btn btn-primary add-btn">+ Tambah Statistik</a>
</div>

@if(session('success'))
    <div class="alert-success">
        {{ session('success') }}
    </div>
@endif

<div class="table-container">
    <table class="data-table">
        <thead>
            <tr>
                <th>Judul</th>
                <th>Nilai</th>
                <th>Satuan</th>
                <th>Periode</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($statistics as $item)
            <tr>
                <td>{{ $item->title }}</td>
                <td>{{ $item->value }}</td>
                <td>{{ $item->unit }}</td>
                <td>{{ $item->period }}</td>
                <td>
                    <form action="/admin/statistics/{{ $item->data_id }}" method="POST" class="delete-form"
                          onsubmit="return confirm('Hapus data statistik ini?')">
                        @csrf
                        @method('DELETE')
                        <button class="btn btn-danger" type="submit">Hapus</button>
                    </form>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
