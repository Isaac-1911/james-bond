<aside class="sidebar">

    <section>
        <h3>Latest News</h3>
        <ul>
            @foreach($latestNews as $item)
                <li>
                    <a href="/news/{{ $item->news_id }}">
                        {{ Str::limit($item->title, 40) }}
                    </a>
                </li>
            @endforeach
        </ul>
    </section>

</aside>
