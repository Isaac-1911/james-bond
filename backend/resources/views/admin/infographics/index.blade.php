@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Manajemen Infografis</h1>
    <a href="/admin/infographics/create" class="btn btn-primary add-btn">+ Tambah Infografis</a>
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
                <th>Preview</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($infographics as $item)
            <tr>
                <td>{{ $item->title }}</td>
                <td>
                    <img src="{{ asset('storage/'.$item->image_url) }}" alt="Preview" class="preview-img">
                </td>
                <td>
                    <form action="/admin/infographics/{{ $item->infographic_id }}" method="POST" class="delete-form"
                          onsubmit="return confirm('Hapus infografis ini?')">
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
