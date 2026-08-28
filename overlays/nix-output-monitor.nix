final: prev:
{
  nix-output-monitor = prev.nix-output-monitor.overrideAttrs (old: {
    # Source-tree patch, applied in postPatch (NOT postInstall): this is a
    # Haskell/cabal package, so the diff targets the unpacked source tree,
    # not compiled/installed files.
    #
    # The nixpkgs v2.2.0 Gitea tarball unpacks to <buildRoot>/nix-output-monitor-2.2.0/
    # and the package's postUnpack resets sourceRoot to the inner package
    # directory (<...>/nix-output-monitor-2.2.0/nix-output-monitor). postPatch
    # runs with cwd=$sourceRoot, and the diff paths are repo-root-relative
    # (a/nix-output-monitor/lib/NOM/Print.hs), so -p2 strips both "a/" and
    # "nix-output-monitor/".
    postPatch =
      (old.postPatch or "")
      + ''
        cat << 'NOM_PATCH' | patch -p2 -f
--- a/nix-output-monitor/lib/NOM/Print.hs
+++ b/nix-output-monitor/lib/NOM/Print.hs
@@ -246,7 +246,6 @@
   lastRow time' = partial_last_row `appendr` one (bold (header time'))

   showHosts = Set.size hosts > 1
-  manyHosts = Set.size buildHosts > 1 || Set.size hosts > 2 -- We only need number labels on hosts if we are using remote builders or more then one transfer peer (normally a substitution cache).
   hostAbbrevs = collisionFreeHandles (setOf (folded % #_Host % _3) hosts)
   showBuilds = totalBuilds > 0
   showDownloads = downloadsDone + downloadsRunning + numPlannedDownloads > 0
@@ -313,14 +312,9 @@
       doneBuilds = action_count_for_host host completedBuilds
     action_count_for_host :: (HasField "host" a (Host WithContext)) => Host WithoutContext -> CMap.CacheIdMap b a -> Int
     action_count_for_host host = CMap.size . CMap.filter (\x -> host == forgetProto x.host)
-  host_name_widths = maximum1 $ 0 :| (Text.length . toText . forgetProto <$> toList hosts)
-  host_abbrevs_widths = maximum1 $ 0 :| (Text.length <$> toList hostAbbrevs)
   host_name_cell :: Host WithoutContext -> Text
   host_name_cell host =
-    showCond
-      manyHosts
-      (Text.justifyLeft (2 + host_abbrevs_widths) ' ' (maybe "" (<> ": ") $ Map.lookup (toText host) hostAbbrevs))
-      <> Text.justifyRight host_name_widths ' ' (toText host)
+    toText host
       <> case toList prots of
         [] -> ""
         ps -> " (" <> Text.intercalate ", " ps <> ")"
@@ -385,7 +379,7 @@
 printBuilds nomState@MkNOMState{..} hostAbbrevs limits = printBuildsWithTime
  where
   hostLabel :: Bool -> Host WithContext -> Text
-  hostLabel color host = (if color then markup magenta else id) $ fromMaybe (toText host) (Map.lookup (toText $ forgetProto host) hostAbbrevs)
+  hostLabel color host = (if color then markup magenta else id) $ toText (forgetProto host)
   printBuildsWithTime :: Double -> NonEmpty Text
   printBuildsWithTime now = (graphHeader :|) $ with_progress $ showForest $ fmap (fmap ($ now)) preparedPrintForest
   with_progress :: [(Text, Maybe Double)] -> [Text]
NOM_PATCH
      '';
  });
}