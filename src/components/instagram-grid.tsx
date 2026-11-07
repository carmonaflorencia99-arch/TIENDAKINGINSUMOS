import type { InstagramPost } from "@/lib/instagram";

/** Grilla de posts de Instagram: cada uno abre el post original. */
export function InstagramGrid({ posts }: { posts: InstagramPost[] }) {
  return (
    <ul className="grid grid-cols-2 gap-2 sm:grid-cols-4">
      {posts.map((p) => (
        <li key={p.id}>
          <a
            href={p.permalink}
            target="_blank"
            rel="noopener"
            className="group relative block aspect-square overflow-hidden bg-surface"
            aria-label={p.caption ? `Ver en Instagram: ${p.caption.slice(0, 80)}` : "Ver en Instagram"}
          >
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={p.image}
              alt={p.caption?.slice(0, 120) ?? "Post de King Insumos en Instagram"}
              loading="lazy"
              className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-[1.04]"
            />
            {p.mediaType === "VIDEO" && (
              <span className="absolute right-2 top-2 bg-ink/70 px-1.5 py-0.5 text-[10px] uppercase tracking-wider text-paper">Video</span>
            )}
            {p.mediaType === "CAROUSEL_ALBUM" && (
              <span className="absolute right-2 top-2 bg-ink/70 px-1.5 py-0.5 text-[10px] uppercase tracking-wider text-paper">+ fotos</span>
            )}
          </a>
        </li>
      ))}
    </ul>
  );
}
