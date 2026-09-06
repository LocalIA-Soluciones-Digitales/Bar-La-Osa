import type { Metadata } from "next";
import { Playfair_Display, Inter } from "next/font/google";
import { SITE } from "@/lib/constants";
import "./globals.css";

const display = Playfair_Display({
  subsets: ["latin"],
  weight: ["500", "600", "700"],
  style: ["normal", "italic"],
  variable: "--font-display",
  display: "swap",
});

const sans = Inter({
  subsets: ["latin"],
  variable: "--font-sans",
  display: "swap",
});

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL ?? "https://barlaosa.es";
const DESCRIPTION =
  "Bar de Tapas La Osa: tapas españolas, raciones, frituras y menú diario en el corazón de Port d'Alcúdia, Mallorca. Terraza, reservas y comida para llevar.";

export const metadata: Metadata = {
  metadataBase: new URL(SITE_URL),
  title: {
    default: `${SITE.name} — ${SITE.tagline}`,
    template: `%s — ${SITE.name}`,
  },
  description: DESCRIPTION,
  keywords: [
    "tapas Mallorca",
    "restaurante Alcúdia",
    "bar de tapas Port d'Alcúdia",
    "gastronomía mediterránea Mallorca",
    "terraza Alcúdia",
    "reservar mesa Alcúdia",
  ],
  authors: [{ name: SITE.name }],
  openGraph: {
    title: `${SITE.name} — ${SITE.tagline}`,
    description: DESCRIPTION,
    siteName: SITE.name,
    locale: "es_ES",
    type: "website",
    url: SITE_URL,
  },
  twitter: {
    card: "summary_large_image",
    title: `${SITE.name} — ${SITE.tagline}`,
    description: DESCRIPTION,
  },
  icons: {
    icon: "/icon.png",
    apple: "/apple-icon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="es" className={`${display.variable} ${sans.variable}`}>
      <body className="flex min-h-screen flex-col font-sans">{children}</body>
    </html>
  );
}
