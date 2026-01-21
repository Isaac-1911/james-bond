@php use Illuminate\Support\Str; @endphp
@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Manajemen News</h1>
    <a href="/admin/news/create" class="btn btn-primary add-btn">+ Tambah News</a>
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
                <th>Tanggal</th>
                <th>Gambar</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($news as $item)
            <tr>
                <td>{{ $item->title }}</td>
                <td>{{ $item->release_date }}</td>
                <td>
                    @if($item->image_url)
                        <img src="{{ Str::startsWith($item->image_url, 'http') ? $item->image_url : asset('storage/' . $item->image_url) }}" alt="{{ $item->title }}" class="preview-img">
                    @else
                        -
                    @endif
                </td>
                <td>
                    <form method="POST" action="/admin/news/{{ $item->news_id }}" class="delete-form"
                          onsubmit="return confirm('Hapus news ini?')">
                        @csrf
                        @method('DELETE')
                        <button class="btn btn-danger">Hapus</button>
                    </form>
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
