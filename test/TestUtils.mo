import Principal "mo:base/Principal";
import Text "mo:base/Text";

module {
  public func principalFromText(t : Text) : Principal {
    Principal.fromBlob(Text.encodeUtf8(t));
  };
}