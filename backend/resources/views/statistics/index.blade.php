@extends('layout')

@section('content')
<div class="page-header">
    <h1 class="page-title">Statistik</h1>
    <p class="page-desc">Data statistik resmi berdasarkan hasil sensus, survei, dan kegiatan statistik lainnya.</p>
</div>

<!-- FILTER -->
<form method="GET" class="filter-box">
    <select name="category">
        <option value="">Semua Kategori</option>
        @foreach($categories as $cat)
            <option value="{{ $cat->category_id }}" {{ request('category') == $cat->category_id ? 'selected' : '' }}>
                {{ $cat->name }}
            </option>
        @endforeach
    </select>
    <button class="btn btn-primary">Tampilkan</button>
</form>

<!-- CHART -->
@if($statistics->count())
<div class="chart-card">
    <h3>{{ $chartTitle }}</h3>
    <canvas id="statisticChart"></canvas>
</div>
@endif

<!-- DATA TABLE -->
<div class="table-card">
    <table class="data-table">
        <thead>
            <tr>
                <th>Judul</th>
                <th>Kategori</th>
                <th>Nilai</th>
                <th>Satuan</th>
                <th>Periode</th>
            </tr>
        </thead>
        <tbody>
            @forelse($statistics as $stat)
            <tr>
                <td>{{ $stat->title }}</td>
                <td>{{ $stat->category?->name }}</td>
                <td>{{ $stat->value }}</td>
                <td>{{ $stat->unit }}</td>
                <td>{{ $stat->period }}</td>
            </tr>
            @empty
            <tr>
                <td colspan="5" class="empty-row">Data statistik belum tersedia.</td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>

<!-- CHART JS -->
@if($statistics->count())
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
const ctx = document.getElementById('statisticChart');

const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
gradient.addColorStop(0, 'rgba(59, 130, 246, 0.8)');
gradient.addColorStop(1, 'rgba(147, 51, 234, 0.8)');

const borderGradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
borderGradient.addColorStop(0, 'rgba(59, 130, 246, 1)');
borderGradient.addColorStop(1, 'rgba(147, 51, 234, 1)');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: {!! json_encode($chartLabels) !!},
        datasets: [{
            label: '{{ $chartTitle }}',
            data: {!! json_encode($chartValues) !!},
            backgroundColor: gradient,
            borderColor: borderGradient,
            borderWidth: 2,
            borderRadius: 8,
            borderSkipped: false,
            hoverBackgroundColor: 'rgba(59, 130, 246, 1)',
            hoverBorderColor: 'rgba(147, 51, 234, 1)',
            hoverBorderWidth: 3,
            shadowOffsetX: 3,
            shadowOffsetY: 3,
            shadowBlur: 10,
            shadowColor: 'rgba(59, 130, 246, 0.5)'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false },
            tooltip: {
                backgroundColor: 'rgba(15, 23, 42, 0.9)',
                titleColor: '#e2e8f0',
                bodyColor: '#cbd5e1',
                borderColor: 'rgba(59, 130, 246, 0.5)',
                borderWidth: 1,
                cornerRadius: 8,
                displayColors: false,
                callbacks: {
                    label: function(context) {
                        return context.parsed.y + ' ({{ $chartUnit ?? "unit" }})';
                    }
                }
            }
        },
        scales: {
            x: {
                grid: {
                    color: 'rgba(255, 255, 255, 0.1)',
                    borderColor: 'rgba(255, 255, 255, 0.2)'
                },
                ticks: {
                    color: '#cbd5e1',
                    font: {
                        size: 12,
                        family: 'JetBrains Mono'
                    }
                }
            },
            y: {
                beginAtZero: true,
                grid: {
                    color: 'rgba(255, 255, 255, 0.1)',
                    borderColor: 'rgba(255, 255, 255, 0.2)'
                },
                ticks: {
                    color: '#cbd5e1',
                    font: {
                        size: 12,
                        family: 'JetBrains Mono'
                    }
                }
            }
        },
        animation: {
            duration: 2000,
            easing: 'easeOutBounce'
        },
        onHover: (event, activeElements) => {
            event.native.target.style.cursor = activeElements.length > 0 ? 'pointer' : 'default';
        }
    }
});
</script>
@endif
@endsection
