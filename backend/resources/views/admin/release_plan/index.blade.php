@php use Illuminate\Support\Str; @endphp
@extends('admin.layout')

@section('content')
<div class="page-header">
    <h1>Manajemen Rencana Terbit</h1>
    <a href="/admin/release-plan/create" class="btn btn-primary add-btn">+ Tambah Rencana Terbit</a>
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
                <th>Tipe</th>
                <th>Rencana Rilis</th>
                <th>Tanggal Rilis</th>
                <th>Target</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($releasePlan as $item)
            <tr>
                <td>{{ $item->title }}</td>
                <td>{{ $item->type }}</td>
                <td>{{ $item->planned_date }}</td>
                <td>{{ $item->release_date }}</td>
                <td>{{ $item->target_id }}</td>
                <td>
                    <form method="POST" action="/admin/news/{{ $item->id }}" class="delete-form"
                          onsubmit="return confirm('Hapus rencana terbit ini?')">
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
