@extends('admin.layout')

@section('content')
<div class="dashboard-header">
    <h1>Dashboard Admin</h1>
    <p class="dashboard-subtitle">
        Kelola konten portal James Bond melalui panel admin
    </p>
</div>

<div class="dashboard-grid">
    <div class="dashboard-card">
        <h3>News</h3>
        <p>Kelola berita publik</p>
        <a href="/admin/news" class="btn btn-primary">Kelola</a>
    </div>

    <div class="dashboard-card">
        <h3>Publications</h3>
        <p>Kelola publikasi & PDF</p>
        <a href="/admin/publications" class="btn btn-primary">Kelola</a>
    </div>

    <div class="dashboard-card">
        <h3>Infographics</h3>
        <p>Kelola infografis</p>
        <a href="/admin/infographics" class="btn btn-primary">Kelola</a>
    </div>

    <div class="dashboard-card">
        <h3>Berita Kegiatan</h3>
        <p>Kelola berita kegiatan</p>
        <a href="/admin/activity-news" class="btn btn-primary">Kelola</a>
    </div>

    <div class="dashboard-card">
        <h3>Rencana Terbit</h3>
        <p>Kelola rencana terbit</p>
        <a href="/admin/release-plan" class="btn btn-primary">Kelola</a>
    </div>
</div>
@endsection
