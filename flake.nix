
              command = "docker-compose down";
            }
            {
              name = "restart";
              category = "docker";
              command = "docker-compose restart";
            }
            {
              name = "yarn";
              category = "javascript";
              package = "yarn";
            }
            {
              name = "node";
              category = "javascript";
              package = "nodejs-16_x";
            }
            {
              name = "exa";
              category = "utility";
              package = "exa";
            }
            {
              name = "fd";
              category = "utility";
              package = "fd";
            }
            {
              name = "rg";
              category = "utility";
              package = "ripgrep";
            }

          ];
          env = [
            {
              name = "RUST_SRC_PATH";
              value = "${rust-bin.stable.latest.rust-src}/lib/rustlib/src/rust/library";
            }
            {
              name = "NODE_ENV";
              value = "development";
            }
            {
              name = "OPENSSL_DIR";
              value = "${openssl.bin}/bin";
            }

            {
              name = "OPENSSL_LIB_DIR";
              value = "${openssl.out}/lib";
            }

            {
              name = "OPENSSL_INCLUDE_DIR";
              value = "${openssl.out.dev}/include";
            }
          ];
        };
      }
    );
}
