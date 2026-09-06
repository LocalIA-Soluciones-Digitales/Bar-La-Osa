"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { NAV_LINKS, SITE } from "@/lib/constants";
import { MobileNav } from "@/components/layout/MobileNav";
import { ThemeToggle } from "@/components/layout/ThemeToggle";
import { Logo } from "@/components/layout/Logo";
import { InstagramIcon } from "@/components/icons";

export function Header() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 40);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  // Solo la home tiene una foto de portada (siempre oscura, en los dos
  // temas) bajo el header transparente; el resto de páginas empiezan con
  // el fondo normal de la página, que ya se adapta con noche-ink. Mientras
  // el header flota sobre esa foto forzamos texto claro fijo, igual que
  // hace HeroSection, para que no se vuelva ilegible en modo día.
  const overPhoto = pathname === "/" && !scrolled && !mobileMenuOpen;

  return (
    <header
      className={`fixed inset-x-0 top-0 z-40 transition-colors duration-300 ${
        scrolled || mobileMenuOpen
          ? "border-b border-noche-border bg-noche-bg/90 backdrop-blur-md"
          : "border-b border-transparent bg-transparent"
      }`}
    >
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6 md:h-20">
        <Link href="/" className="transition-colors">
          <Logo size="sm" light={overPhoto} />
        </Link>

        <nav className="hidden items-center gap-8 md:flex">
          {NAV_LINKS.map((link) => {
            const active = pathname?.startsWith(link.href);
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`text-sm transition-colors hover:text-noche-primary ${
                  active ? "text-noche-primary" : overPhoto ? "text-white/85" : "text-noche-ink/80"
                }`}
              >
                {link.label}
              </Link>
            );
          })}
          <Link
            href="/admin/login"
            className={`inline-flex items-center rounded-full border px-5 py-2.5 text-sm font-medium transition-colors hover:border-noche-primary hover:text-noche-primary ${
              overPhoto ? "border-white/30 text-white/85" : "border-noche-border text-noche-ink/80"
            }`}
          >
            Panel de gestión
          </Link>
          <Link
            href="/pedir"
            className="inline-flex items-center rounded-full bg-noche-primary px-5 py-2.5 text-sm font-medium text-white transition-colors hover:bg-noche-primary-dark"
          >
            Pedir
          </Link>
          {SITE.instagram ? (
            <a
              href={SITE.instagram.url}
              target="_blank"
              rel="noreferrer"
              aria-label={`Instagram de ${SITE.name}`}
              className={`transition-colors hover:text-noche-primary ${overPhoto ? "text-white/70" : "text-noche-ink-muted"}`}
            >
              <InstagramIcon className="h-5 w-5" />
            </a>
          ) : null}
          <ThemeToggle
            className={
              overPhoto
                ? "flex h-9 w-9 items-center justify-center rounded-full border border-white/30 text-white/80 transition-colors hover:border-noche-primary hover:text-noche-primary"
                : undefined
            }
          />
        </nav>

        <div className="flex items-center gap-2 md:hidden">
          <ThemeToggle
            className={
              overPhoto
                ? "flex h-9 w-9 items-center justify-center rounded-full border border-white/30 text-white/80 transition-colors hover:border-noche-primary hover:text-noche-primary"
                : undefined
            }
          />
          <MobileNav open={mobileMenuOpen} onOpenChange={setMobileMenuOpen} light={overPhoto} />
        </div>
      </div>
    </header>
  );
}
