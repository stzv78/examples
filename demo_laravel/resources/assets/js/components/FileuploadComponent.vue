<template>
<div>
    <div class="document document_flex" v-for="upload in files">
        <span class="document__title">Документ-рейс</span>
            {{ upload.name }}
        <div class="document__links">
            <a :href="upload.path" class="document__link">Скачать</a>
        </div>
    </div>

    <div class="document document_upload">

        <div class="upload-btn-wrapper">
            <div class="upload-btn">
                Добавить документ
            </div>
            <input class="upload-input" id="file" ref="file" type="file" @change="uploadFile" />
        </div>

    </div>
</div>
</template>

<script>
    export default {
        props: [
            'lunit',
        ],

        data() {
            return {
                file: '',
                files: [],
            }
        },

        mounted() {

        },

        methods: {
            getFiles() {
                axios.get('/'+this.lunit+'/files').then(response => {
                     this.files = response.data.files
                     console.log(response)
                })
                 .catch(error => {
                 console.log(error)
                });
            },
            uploadFile(e){
                this.file = e.target.files[0];
                let formData = new FormData();
                formData.append('file', this.file);
                let route = '/files/add/'+this.lunit;
                axios.post(route, formData).then(response => {
                    console.log(response.data)
                    this.files.push(response.data.file)
                })
                .catch(error => {
                    console.log(error)
                });
            }

        }
}
</script>
