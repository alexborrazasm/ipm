let networkErrorCallback;

const config = {
  BASE_PATH: "http://localhost:8000"
};

const isJson = (response) => {
  const contentType = response.headers.get("content-type");
  return contentType && contentType.indexOf("application/json") !== -1;
};

const handleResponse = async (response) => {
  if (response.ok) {
    if (response.status === 204) return null;
    return isJson(response) ? await response.json() : await response.blob();
  }

  if (response.status >= 400 && response.status < 500) {
    if (isJson(response)) {
      try {
        const payload = await response.json();
        if (payload.globalError || payload.fieldErrors) throw payload;
        throw { globalError: `Error ${response.status}: ${response.statusText}` };
      } catch (err) {
        throw err.globalError ? err : { globalError: err };
      }
    } else {
      throw { globalError: `Error ${response.status}: ${response.statusText}` };
    }
  }

  if (response.status >= 500 && response.status < 600) {
    if (isJson(response)) {
      try {
        const payload = await response.json();
        throw payload || { globalError: `Server error: ${response.status}` };
      } catch {
        throw { globalError: `Server error: ${response.status}` };
      }
    } else {
      throw { globalError: `Server error: ${response.status}` };
    }
  }

  throw { globalError: "Unknown error" };
};

export const init = (callback) => (networkErrorCallback = callback);

export const fetchConfig = (method, body) => {
  const fConfig = { method };

  if (body) {
    if (body instanceof FormData) {
      fConfig.body = body;
    } else {
      fConfig.headers = { "Content-Type": "application/json" };
      fConfig.body = JSON.stringify(body);
    }
  }

  return fConfig;
};

export const appFetch = async (path, options) => {
  try {
    const response = await fetch(`${config.BASE_PATH}${path}`, options);
    return await handleResponse(response);
  } catch (error) {
    networkErrorCallback?.(error);
    throw new Error(error.globalError || "Network error");
  }
};
