"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { getPedidoPublico } from "@/lib/restaurant/queries";
import { formatCentimos } from "@/lib/format";
import { CheckIcon, ClockIcon, RefreshIcon } from "@/components/icons";
import { StatusBadge } from "@/components/mesa/StatusBadge";
import { guardarPedidoActivo, olvidarPedido } from "@/lib/pedido/active-orders";
import { playNewOrderChime } from "@/lib/notify-sound";
import { vibrarSuave } from "@/lib/haptics";
import type { EstadoPedido, PaymentStatus, PedidoPublico } from "@/lib/restaurant/types";

const PASOS: { estado: EstadoPedido; label: string }[] = [
  { estado: "RECEIVED", label: "Pedido recibido" },
  { estado: "ACCEPTED", label: "Pedido aceptado" },
  { estado: "PREPARING", label: "En preparación" },
  { estado: "READY", label: "Listo" },
  { estado: "DELIVERED", label: "Entregado" },
];

const ESTADOS_FINALES: EstadoPedido[] = ["DELIVERED", "CANCELLED"];
const INTERVALO_MS = 5000;

/** Badge del estado real del pago online: la confirmación solo llega por webhook de Stripe. */
function PaymentStatusPill({ status }: { status: PaymentStatus }) {
  switch (status) {
    case "PAID":
      return (
        <StatusBadge icon={<CheckIcon className="h-3 w-3" />} label="Pago confirmado" variant="positive" />
      );
    case "FAILED":
      return <StatusBadge icon={<ClockIcon className="h-3 w-3" />} label="Pago fallido" variant="danger" />;
    case "REFUNDED":
      return <StatusBadge label="Pago reembolsado" variant="neutral" />;
    case "PENDING":
    default:
      return (
        <StatusBadge
          icon={<ClockIcon className="h-3 w-3" />}
          label="Confirmando pago…"
          variant="warning"
        />
      );
  }
}

export function PedidoStatus({ pedidoInicial }: { pedidoInicial: PedidoPublico }) {
  const [pedido, setPedido] = useState(pedidoInicial);
  const estadoAnterior = useRef(pedidoInicial.estado);

  useEffect(() => {
    if (ESTADOS_FINALES.includes(pedido.estado)) {
      olvidarPedido(pedido.id);
    } else {
      guardarPedidoActivo(pedido.id);
    }
  }, [pedido.estado, pedido.id]);

  // Avisa (sonido + vibración) en cuanto el pedido pasa a "Listo", para que
  // el cliente no tenga que estar mirando la pantalla mientras espera.
  useEffect(() => {
    if (pedido.estado === "READY" && estadoAnterior.current !== "READY") {
      playNewOrderChime();
      vibrarSuave();
    }
    estadoAnterior.current = pedido.estado;
  }, [pedido.estado]);

  useEffect(() => {
    if (ESTADOS_FINALES.includes(pedido.estado)) return;

    const interval = setInterval(async () => {
      const actualizado = await getPedidoPublico(pedido.id);
      if (actualizado) setPedido(actualizado);
    }, INTERVALO_MS);

    return () => clearInterval(interval);
  }, [pedido.estado, pedido.id]);

  const pasoActualIndex = PASOS.findIndex((p) => p.estado === pedido.estado);
  const cancelado = pedido.estado === "CANCELLED";

  return (
    <div className="mx-auto max-w-lg px-6 py-24">
      <p className="text-xs uppercase tracking-widest2 text-noche-primary">
        {pedido.mesa_numero
          ? pedido.mesa_nombre
            ? `${pedido.mesa_nombre} (Mesa ${pedido.mesa_numero})`
            : `Mesa ${pedido.mesa_numero}`
          : "Pedido"}
      </p>
      <h1 className="mt-4 font-display text-4xl text-noche-ink">
        Pedido #{pedido.id.slice(0, 8)}
      </h1>

      <div className="mt-4">
        {pedido.payment_method === "LOCAL" ? (
          <StatusBadge label="Pago en local" variant="neutral" />
        ) : (
          <PaymentStatusPill status={pedido.payment_status} />
        )}
      </div>

      {pedido.payment_method === "ONLINE" && pedido.payment_status === "PENDING" ? (
        <p className="mt-3 text-sm text-noche-ink-muted">
          Estamos confirmando tu pago con el banco. Esta página se actualiza sola en cuanto
          se confirme, no hace falta que la recargues.
        </p>
      ) : null}

      {cancelado ? (
        <p className="mt-8 text-noche-ink-muted">Este pedido ha sido cancelado.</p>
      ) : (
        <ol className="mt-10 space-y-4">
          {PASOS.map((paso, index) => {
            const alcanzado = index <= pasoActualIndex;
            const conectorLleno = index < pasoActualIndex;
            const esUltimo = index === PASOS.length - 1;
            return (
              <li key={paso.estado} className="relative flex items-center gap-3">
                {!esUltimo ? (
                  <span
                    aria-hidden="true"
                    className={`absolute left-[13px] top-7 h-4 w-0.5 transition-colors duration-700 ${
                      conectorLleno ? "bg-noche-primary" : "bg-noche-surface-2"
                    }`}
                  />
                ) : null}
                <span
                  className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-full transition-colors duration-500 ${
                    alcanzado ? "bg-noche-primary text-white" : "bg-noche-surface-2 text-noche-ink-faint"
                  } ${index === pasoActualIndex ? "ring-4 ring-noche-primary/25" : ""}`}
                >
                  {alcanzado ? <CheckIcon className="h-4 w-4" /> : null}
                </span>
                <span
                  className={`transition-colors duration-500 ${
                    alcanzado ? "text-noche-ink" : "text-noche-ink-faint"
                  }`}
                >
                  {paso.label}
                </span>
              </li>
            );
          })}
        </ol>
      )}

      {pedido.estado === "READY" ? (
        <p className="mt-8 font-display text-xl text-noche-primary">
          ¡Tu pedido está listo! Nuestro equipo lo llevará a tu mesa.
        </p>
      ) : null}

      <div className="mt-12 rounded-lg border border-noche-border bg-noche-surface/40 p-4">
        <ul className="space-y-2">
          {pedido.items.map((item, index) => (
            <li key={index} className="flex justify-between text-sm text-noche-ink/90">
              <span>
                {item.cantidad} × {item.producto_nombre}
              </span>
              <span>{formatCentimos(item.precio_unitario_centimos * item.cantidad)} €</span>
            </li>
          ))}
        </ul>
        <div className="mt-4 flex justify-between border-t border-noche-border pt-4 font-medium text-noche-ink">
          <span>Total</span>
          <span>{formatCentimos(pedido.total_centimos)} €</span>
        </div>
      </div>

      <Link
        href={`/pedir?repetir=${pedido.id}`}
        className="mt-6 flex items-center justify-center gap-1.5 rounded-lg border border-noche-border py-3 text-sm uppercase tracking-widest2 text-noche-ink-muted transition-colors hover:border-noche-primary hover:text-noche-primary"
      >
        <RefreshIcon className="h-3.5 w-3.5" />
        Pedir lo mismo otra vez
      </Link>
    </div>
  );
}
