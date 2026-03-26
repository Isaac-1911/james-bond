@extends('admin.layout')

@section('content')
    <div class="page-header">
        <h1>Tambah News</h1>
        <p class="page-desc">Tambahkan berita baru yang akan ditampilkan di portal publik.</p>
    </div>

    @if ($errors->any())
        <div class="alert-error">
            <ul>
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <div class="form-card">
        <form action="/admin/release-plan" method="POST" enctype="multipart/form-data">
            @csrf

            <div class="form-group">
                <label>Judul</label>
                <input type="text" name="title" placeholder="Judul rencana terbit" value="{{ old('title') }}" required>
            </div>

            <div class="form-group">
                <label>Tipe Rencana Terbit</label>
                <select name="type" required>
                    <option value="">-- Pilih tipe rencana terbit --</option>
                    <option value="publikasi" {{ old('type') == 'publikasi' ? 'selected' : '' }}>
                        Publikasi
                    </option>
                    <option value="brs" {{ old('type') == 'brs' ? 'selected' : '' }}>
                        BRS
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label>Tanggal Rencana Terbit </label>
                <input type="date" name="planned_date" value="{{ old('planned_date') }}">
            </div>

            <div class="form-group">
                <label>Tanggal Terbit (Opsional)</label>
                <input type="date" name="released_date" value="{{ old('released_date') }}">
            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Simpan</button>
                <a href="/admin/news" class="btn btn-secondary">Batal</a>
            </div>
        </form>
    </div>
@endsection
