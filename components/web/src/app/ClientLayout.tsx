"use client";

import { usePathname } from "next/navigation";
import Navigation from "./components/Navigation";
import NoSSR from "./components/NoSSR";

export default function ClientLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  console.log("test");

  // Don't show navigation on the home page to keep it clean
  const showNavigation = pathname !== "/";

  return (
    <>
      <NoSSR>{showNavigation && <Navigation />}</NoSSR>
      {children}
    </>
  );
}
