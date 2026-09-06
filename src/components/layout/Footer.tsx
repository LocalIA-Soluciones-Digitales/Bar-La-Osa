"use client";

import Link from "next/link";
import { useState, type FormEvent } from "react";
import { NAV_LINKS, SITE } from "@/lib/constants";
import { Logo } from "@/components/layout/Logo";
import { InstagramIcon, MapPinIcon, CheckIcon } from "@/components/icons";

export function Footer() {
  const [email, setEmail] = useState("");

  const mapQuery = encodeURIComponent(
    `${SITE.name} ${SITE.address.line1}, ${SITE.address.postalCode} ${SITE.address.city}`,
  );
  const mapsUrl = `https://www.google.com/maps/search/?api=1&query=${mapQuery}`;

  const handleNewsletter = (event: FormEvent) => {
    event.preventDefault();
    if (!email) return;
    // Sin backend de newsletter conectado todavía: abrimos el cliente de
    // correo con la suscripción ya redactada en vez de simular un envío
    // que no llegaría a ningún sitio.
    window.location.href = `mailto:hola@barlaosa.es?subject=${encodeURIComponent(
      "Alta en newsletter",
    )}&body=${encodeURIComponent(`Quiero apuntarme a la newsletter de ${SITE.name}: ${email}`)}`;
  };

  return (
    <footer className="border-t border-noche-border bg-noche-surface text-noche-ink">
      <div className="mx-auto max-w-7xl px-6 py-16">
        <div className="grid gap-12 lg:grid-cols-4">
          <div className="lg:col-span-1">
            <Logo size="md" />
            <p className="mt-4 max-w-xs text-sm text-noche-ink-muted">
              Tapas, tradición mediterránea y momentos inolvidables en el corazón de Port
              d&apos;Alcúdia.
            </p>
            {SITE.instagram ? (
              <a
                href={SITE.instagram.url}
                target="_blank"
                rel="noreferrer"
                className="mt-4 inline-flex items-center gap-2 text-sm text-noche-ink-muted transition-colors hover:text-noche-primary"
              >
                <InstagramIcon className="h-4 w-4" />
                {SITE.instagram.handle}
              </a>
            ) : null}
          </div>

          <div>
            <p className="text-sm font-medium text-noche-ink-muted">Navegación</p>
            <ul className="mt-4 space-y-2">
              {NAV_LINKS.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-noche-ink/80 transition-colors hover:text-noche-primary"
                  >
                    {link.label}
                  </Link>
                </li>
              ))}
              <li>
                <a
                  href={mapsUrl}
                  target="_blank"
                  rel="noreferrer"
                  className="inline-flex items-center gap-1.5 text-sm text-noche-ink/80 transition-colors hover:text-noche-primary"
                >
                  <MapPinIcon className="h-4 w-4" />
                  Cómo llegar
                </a>
              </li>
            </ul>
          </div>

          <div>
            <p className="text-sm font-medium text-noche-ink-muted">Visítanos</p>
            <address className="mt-4 space-y-1 text-sm not-italic text-noche-ink/80">
              <p>{SITE.address.line1}</p>
              <p>
                {SITE.address.postalCode} {SITE.address.city}, {SITE.address.province}
              </p>
              {SITE.phone ? (
                <p>
                  <a href={SITE.phoneHref ?? undefined} className="transition-colors hover:text-noche-primary">
                    {SITE.phone}
                  </a>
                  {SITE.phoneSecondary ? (
                    <>
                      {" · "}
                      <a
                        href={SITE.phoneSecondaryHref ?? undefined}
                        className="transition-colors hover:text-noche-primary"
                      >
                        {SITE.phoneSecondary}
                      </a>
                    </>
                  ) : null}
                </p>
              ) : null}
            </address>
          </div>

          <div>
            <p className="text-sm font-medium text-noche-ink-muted">Newsletter</p>
            <p className="mt-4 text-sm text-noche-ink/70">
              Novedades de temporada, eventos y la carta de cada mes.
            </p>
            <form onSubmit={handleNewsletter} className="mt-4 flex gap-2">
              <label htmlFor="footer-newsletter" className="sr-only">
                Correo electrónico
              </label>
              <input
                id="footer-newsletter"
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Tu correo"
                className="min-w-0 flex-1 rounded-lg border border-noche-border bg-noche-bg px-3 py-2.5 text-sm text-noche-ink placeholder:text-noche-ink-faint outline-none transition-colors focus:border-noche-primary"
              />
              <button
                type="submit"
                aria-label="Suscribirme a la newsletter"
                className="flex shrink-0 items-center justify-center rounded-lg bg-noche-primary px-3 text-white transition-colors hover:bg-noche-primary-dark"
              >
                <CheckIcon className="h-4 w-4" />
              </button>
            </form>
          </div>
        </div>

        <div className="mt-16 flex flex-wrap items-center justify-between gap-4 border-t border-noche-border pt-6">
          <p className="text-xs text-noche-ink-muted">
            © {new Date().getFullYear()} {SITE.name} · {SITE.address.city}, {SITE.address.province}
          </p>
        </div>
      </div>
    </footer>
  );
}
