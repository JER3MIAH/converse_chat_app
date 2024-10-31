// Function to trim mongodb generated properties like "_id" and "__v" so its
// not part of the response payload 
export const trimUserModel = (user) => {
    return {
        userId: user._id,
        username: user.username || null,
        email: user.email,
    };
};
