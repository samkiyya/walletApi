namespace WalletApi.Common.Exceptions;

public sealed class NotFoundException : DomainException
{
    public string ResourceType { get; }
    public object ResourceId { get; }

    public NotFoundException(string resourceType, object resourceId)
        : base($"{resourceType} with ID '{resourceId}' was not found.")
    {
        ResourceType = resourceType;
        ResourceId = resourceId;
    }
}
