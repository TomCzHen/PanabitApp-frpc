new Vue({
    el: '#app',
    data() {
        return {
            frpc: {
                config: "",
                status: "",
                message: ""
            },
            dialog: false,
            upload_config: "",
            loading: {
                fetch: false,
                upload: false
            }
        }
    },
    computed: {
        iniFile: function () {
            return new Blob([this.upload_config], {type: 'text/plain'});
        }
    },
    mounted: function () {
        this.fetchStatus();
    },
    methods: {
        fetchStatus() {
            this.loadingToggle('fetch');
            fetch('frpc', {
                credentials: 'include',
                method: 'GET'
            }).then((response) => {
                    return response.json()
                }
            ).then((frpc) => {
                this.frpc = frpc;
                this.upload_config = frpc.config;
                this.loadingToggle('fetch');
            }).catch(
                function (error) {
                    alert(error)
                }
            )
        },
        uploadConfig() {
            this.loadingToggle('upload');
            let formData = new FormData();
            formData.append('config_file', this.iniFile);
            fetch('frpc', {
                method: 'POST',
                credentials: 'include',
                body: formData
            }).then((response) => {
                    return response.json()
                }
            ).then((frpc) => {
                this.frpc = frpc;
                this.fetchStatus();
                this.loadingToggle('upload');
            }).catch(
                function (error) {
                    alert(error)
                }
            ).finally(
                () => {
                    this.dialogToggle()
                }
            )
        },
        dialogToggle() {
            this.dialog = !this.dialog
        },
        loadingToggle(name) {
            this.loading[name] = !this.loading[name]
        }
    }
});