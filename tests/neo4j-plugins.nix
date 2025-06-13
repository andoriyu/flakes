{pkgs, ...}:
pkgs.nixosTest {
  name = "neo4j-plugins";
  nodes.server = {
    config,
    pkgs,
    ...
  }: {
    services.neo4j = {
      enable = true;
      https.enable = false;
      bolt = {
        enable = true;
        listenAddress = ":7687";
        advertisedAddress = ":7687";
        tlsLevel = "DISABLED";
      };
      plugins = [pkgs.neo4j-apoc];
      extraServerConfig = ''
        dbms.security.auth_enabled=false
        server.jvm.additional=-Xmx512m
        server.memory.heap.initial_size=256m
        server.memory.heap.max_size=512m
        server.memory.pagecache.size=256m
        dbms.security.procedures.unrestricted=apoc.*
        dbms.security.procedures.allowlist=apoc.*
      '';
    };
    imports = [../modules/neo4j-plugins.nix];
  };
  testScript = ''
    start_all()
    server.wait_for_unit("neo4j.service")
    # Add more debugging
    server.execute("journalctl -u neo4j.service")
    server.execute("ls -la /var/lib/neo4j/plugins/")
    # Increase timeout for port waiting
    server.wait_for_open_port(7687, timeout=120)
    server.succeed("cypher-shell -u neo4j -p neo4j 'RETURN 1' > /dev/null")
    server.succeed("cypher-shell -u neo4j -p neo4j 'CALL apoc.help(\"apoc\")'")
  '';
}
